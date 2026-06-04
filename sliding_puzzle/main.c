#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASH_MULTIPLIER 1013

typedef struct BoardBlock {
	unsigned char *boards;
	int used;
	int capacity;
	struct BoardBlock *next;
} BoardBlock;

typedef struct Node {
	unsigned char *board;
	unsigned long long hash;
	int parent;
	int move;
	int hash_next;
	int blank_index;
	int previous_direction;
} Node;

typedef struct Solver {
	Node *nodes;
	int node_count;
	int node_capacity;
	int *queue;
	int queue_head;
	int queue_tail;
	int queue_count;
	int queue_capacity;
	int *hash_heads;
	int hash_size;
	int board_size;
	BoardBlock *board_blocks;
} Solver;

static void *checked_malloc(size_t size) {
	void *ptr = malloc(size);
	if (ptr == NULL) {
		fprintf(stderr, "Memory allocation failed\n");
		exit(EXIT_FAILURE);
	}
	return ptr;
}

static int boards_equal(const unsigned char *a, const unsigned char *b, int n) {
	return memcmp(a, b, (size_t)n * sizeof(unsigned char)) == 0;
}

static unsigned long long hash_board(const unsigned char *board, int n){
	unsigned long long hash = 14695981039346656037ULL;
	for (int i = 0; i < n; i++){
		hash ^= (unsigned long long)(board[i] + 1);
		hash *= 1099511628211ULL;
	}
	return hash;
}

static BoardBlock *new_board_block(int board_size)
{
    BoardBlock *block = checked_malloc(sizeof(BoardBlock));
    block->capacity = 4096;
    block->used = 0;
    block->boards = checked_malloc((size_t)block->capacity * (size_t)board_size * sizeof(unsigned char));
    block->next = NULL;
    return block;
}

static int calculate_hash_size(int k)
{
    return HASH_MULTIPLIER * (k * (k - 1) - 1);
}

static void init_solver(Solver *solver, int board_size, int k)
{
    solver->board_size = board_size;

    solver->node_capacity = 1024;
    solver->node_count = 0;
    solver->nodes = checked_malloc((size_t)solver->node_capacity * sizeof(Node));

    solver->queue_capacity = 1024;
    solver->queue_head = 0;
    solver->queue_tail = 0;
    solver->queue_count = 0;
    solver->queue = checked_malloc((size_t)solver->queue_capacity * sizeof(int));

    solver->hash_size = calculate_hash_size(k);
    solver->hash_heads = checked_malloc((size_t)solver->hash_size * sizeof(int));
    for (int i = 0; i < solver->hash_size; i++) {
        solver->hash_heads[i] = -1;
    }

    solver->board_blocks = NULL;
}

static void free_solver(Solver *solver)
{
    BoardBlock *block = solver->board_blocks;
    while (block != NULL) {
        BoardBlock *next = block->next;
        free(block->boards);
        free(block);
        block = next;
    }
    free(solver->nodes);
    free(solver->queue);
    free(solver->hash_heads);
}

static unsigned char *allocate_board(Solver *solver)
{
    if (solver->board_blocks == NULL || solver->board_blocks->used >= solver->board_blocks->capacity) {
        BoardBlock *block = new_board_block(solver->board_size);
        block->next = solver->board_blocks;
        solver->board_blocks = block;
    }

    BoardBlock *block = solver->board_blocks;
    unsigned char *board = block->boards + (size_t)block->used * (size_t)solver->board_size;
    block->used++;
    return board;
}

static void ensure_node_capacity(Solver *solver)
{
    if (solver->node_count < solver->node_capacity) {
        return;
    }
    solver->node_capacity *= 2;
    solver->nodes = realloc(solver->nodes, (size_t)solver->node_capacity * sizeof(Node));
    if (solver->nodes == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(EXIT_FAILURE);
    }
}

static void enqueue(Solver *solver, int node_index)
{
    if (solver->queue_count >= solver->queue_capacity) {
        int new_capacity = solver->queue_capacity * 2;
        int *new_queue = checked_malloc((size_t)new_capacity * sizeof(int));
        for (int i = 0; i < solver->queue_count; i++) {
            new_queue[i] = solver->queue[(solver->queue_head + i) % solver->queue_capacity];
        }
        free(solver->queue);
        solver->queue = new_queue;
        solver->queue_capacity = new_capacity;
        solver->queue_head = 0;
        solver->queue_tail = solver->queue_count;
    }
    solver->queue[solver->queue_tail] = node_index;
    solver->queue_tail = (solver->queue_tail + 1) % solver->queue_capacity;
    solver->queue_count++;
}

static int dequeue(Solver *solver)
{
    int node_index = solver->queue[solver->queue_head];
    solver->queue_head = (solver->queue_head + 1) % solver->queue_capacity;
    solver->queue_count--;
    return node_index;
}

static int queue_empty(const Solver *solver)
{
    return solver->queue_count == 0;
}

static int hash_bucket(const Solver *solver, unsigned long long hash)
{
    return (int)(hash % (unsigned long long)solver->hash_size);
}

static int visited_contains_in_bucket(const Solver *solver, const unsigned char *board,
                                      unsigned long long hash, int bucket)
{
    for (int node_index = solver->hash_heads[bucket]; node_index != -1; node_index = solver->nodes[node_index].hash_next) {
        if (solver->nodes[node_index].hash == hash &&
            boards_equal(solver->nodes[node_index].board, board, solver->board_size)) {
            return 1;
        }
    }
    return 0;
}

static int add_node_take_board(Solver *solver, unsigned char *board, int parent, int move,
                               int blank_index, int previous_direction,
                               unsigned long long hash, int bucket)
{
    ensure_node_capacity(solver);

    int node_index = solver->node_count++;
    solver->nodes[node_index].board = board;
    solver->nodes[node_index].hash = hash;
    solver->nodes[node_index].parent = parent;
    solver->nodes[node_index].move = move;
    solver->nodes[node_index].blank_index = blank_index;
    solver->nodes[node_index].previous_direction = previous_direction;

    solver->nodes[node_index].hash_next = solver->hash_heads[bucket];
    solver->hash_heads[bucket] = node_index;

    enqueue(solver, node_index);
    return node_index;
}

static int add_node(Solver *solver, const unsigned char *board, int parent, int move,
                    int blank_index, int previous_direction)
{
    unsigned char *board_copy = allocate_board(solver);
    memcpy(board_copy, board, (size_t)solver->board_size * sizeof(unsigned char));
    unsigned long long hash = hash_board(board_copy, solver->board_size);
    return add_node_take_board(solver, board_copy, parent, move, blank_index, previous_direction,
                               hash, hash_bucket(solver, hash));
}

static int is_solvable(const unsigned char *board, int k)
{
    int n = k * k;
    int inversions = 0;
    int blank_row_from_top = 0;

    for (int i = 0; i < n; i++) {
        if (board[i] == 0) {
            blank_row_from_top = i / k;
            continue;
        }

        for (int j = i + 1; j < n; j++) {
            if (board[j] != 0 && board[i] > board[j]) {
                inversions++;
            }
        }
    }

    if (k % 2 == 1) {
        return inversions % 2 == 0;
    }

    int blank_row_from_bottom = k - blank_row_from_top;

    return (inversions + blank_row_from_bottom) % 2 == 1;
}

static int find_blank(const unsigned char *board, int n)
{
    for (int i = 0; i < n; i++) {
        if (board[i] == 0) {
            return i;
        }
    }
    return -1;
}

static int solve_puzzle(const unsigned char *initial_board, int k, int **moves_out)
{
    int n = k * k;
    unsigned char *goal = checked_malloc((size_t)n * sizeof(unsigned char));
    for (int i = 0; i < n - 1; i++) {
        goal[i] = (unsigned char)(i + 1);
    }
    goal[n - 1] = 0;

    Solver solver;
    init_solver(&solver, n, k);
    add_node(&solver, initial_board, -1, -1, find_blank(initial_board, n), -1);
    unsigned char *candidate_board = checked_malloc((size_t)n * sizeof(unsigned char));

    int goal_index = -1;
    const int row_change[4] = {-1, 1, 0, 0};
    const int col_change[4] = {0, 0, -1, 1};
    const int opposite_direction[4] = {1, 0, 3, 2};

    while (!queue_empty(&solver)) {
        int current_index = dequeue(&solver);
        unsigned char *current_board = solver.nodes[current_index].board;

        if (boards_equal(current_board, goal, n)) {
            goal_index = current_index;
            break;
        }

        int blank_index = solver.nodes[current_index].blank_index;
        int blank_row = blank_index / k;
        int blank_col = blank_index % k;

        for (int d = 0; d < 4; d++) {
            if (solver.nodes[current_index].previous_direction != -1 &&
                d == opposite_direction[solver.nodes[current_index].previous_direction]) {
                continue;
            }

            int new_row = blank_row + row_change[d];
            int new_col = blank_col + col_change[d];

            if (new_row < 0 || new_row >= k || new_col < 0 || new_col >= k) {
                continue;
            }

            int tile_index = new_row * k + new_col;
            memcpy(candidate_board, current_board, (size_t)n * sizeof(unsigned char));
            candidate_board[blank_index] = candidate_board[tile_index];
            candidate_board[tile_index] = 0;

            unsigned long long hash = hash_board(candidate_board, n);
            int bucket = hash_bucket(&solver, hash);
            if (!visited_contains_in_bucket(&solver, candidate_board, hash, bucket)) {
                unsigned char *stored_board = allocate_board(&solver);
                memcpy(stored_board, candidate_board, (size_t)n * sizeof(unsigned char));
                add_node_take_board(&solver, stored_board, current_index, current_board[tile_index],
                                    tile_index, d, hash, bucket);
            }
        }
    }

    free(candidate_board);
    free(goal);

    if (goal_index == -1) {
        free_solver(&solver);
        *moves_out = NULL;
        return -1;
    }

    int move_count = 0;
    for (int index = goal_index; solver.nodes[index].parent != -1; index = solver.nodes[index].parent) {
        move_count++;
    }

    int *moves = checked_malloc((size_t)(move_count == 0 ? 1 : move_count) * sizeof(int));
    int write_index = move_count - 1;
    for (int index = goal_index; solver.nodes[index].parent != -1; index = solver.nodes[index].parent) {
        moves[write_index--] = solver.nodes[index].move;
    }

    free_solver(&solver);
    *moves_out = moves;
    return move_count;
}

int main(int argc, char **argv)
{
    if (argc != 3) {
        printf("Usage: %s input output\n", argv[0]);
        return -1;
    }

    FILE *fp_in = fopen(argv[1], "r");
    if (fp_in == NULL) {
        printf("Could not open a file.\n");
        return -1;
    }

    FILE *fp_out = fopen(argv[2], "w");
    if (fp_out == NULL) {
        printf("Could not open a file.\n");
        fclose(fp_in);
        return -1;
    }

    char line[256];
    int k;

    fgets(line, sizeof(line), fp_in);
    fscanf(fp_in, "%d\n", &k);
    fgets(line, sizeof(line), fp_in);

    if (k < 2) {
        fclose(fp_in);
        fprintf(fp_out, "#moves\n");
        fprintf(fp_out, "no solution\n");
        fclose(fp_out);
        return 0;
    }

    int n = k * k;
    unsigned char *initial_board = checked_malloc((size_t)n * sizeof(unsigned char));
    int invalid_input = 0;
    for (int i = 0; i < n; i++) {
        int tile;
        fscanf(fp_in, "%d", &tile);
        if (tile < 0 || tile >= n) {
            invalid_input = 1;
        }
        initial_board[i] = (unsigned char)tile;
    }
    fclose(fp_in);

    fprintf(fp_out, "#moves\n");

    if (invalid_input || !is_solvable(initial_board, k)) {
        fprintf(fp_out, "no solution\n");
        free(initial_board);
        fclose(fp_out);
        return 0;
    }

    int *moves = NULL;
    int number_of_moves = solve_puzzle(initial_board, k, &moves);
    if (number_of_moves < 0) {
        fprintf(fp_out, "no solution\n");
    } else {
        for (int i = 0; i < number_of_moves; i++) {
            fprintf(fp_out, "%d ", moves[i]);
        }
        fprintf(fp_out, "\n");
    }

    free(moves);
    free(initial_board);
    fclose(fp_out);
    return 0;
}
