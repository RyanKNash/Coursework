#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node {
    int *board;
    int parent;
    int move;
    int hash_next;
} Node;

typedef struct Solver {
    Node *nodes;
    int node_count;
    int node_capacity;
    int *queue;
    int queue_head;
    int queue_tail;
    int queue_capacity;
    int *hash_heads;
    int hash_size;
    int board_size;
} Solver;

static void *checked_malloc(size_t size)
{
    void *ptr = malloc(size);
    if (ptr == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(EXIT_FAILURE);
    }
    return ptr;
}

static int boards_equal(const int *a, const int *b, int n)
{
    for (int i = 0; i < n; i++) {
        if (a[i] != b[i]) {
            return 0;
        }
    }
    return 1;
}

static unsigned long long hash_board(const int *board, int n)
{
    unsigned long long hash = 1469598103934665603ULL;
    for (int i = 0; i < n; i++) {
        hash ^= (unsigned long long)(board[i] + 1);
        hash *= 1099511628211ULL;
    }
    return hash;
}

static void init_solver(Solver *solver, int board_size)
{
    solver->node_capacity = 1024;
    solver->node_count = 0;
    solver->nodes = checked_malloc((size_t)solver->node_capacity * sizeof(Node));

    solver->queue_capacity = 1024;
    solver->queue_head = 0;
    solver->queue_tail = 0;
    solver->queue = checked_malloc((size_t)solver->queue_capacity * sizeof(int));

    solver->hash_size = 1000003;
    solver->hash_heads = checked_malloc((size_t)solver->hash_size * sizeof(int));
    for (int i = 0; i < solver->hash_size; i++) {
        solver->hash_heads[i] = -1;
    }

    solver->board_size = board_size;
}

static void free_solver(Solver *solver)
{
    for (int i = 0; i < solver->node_count; i++) {
        free(solver->nodes[i].board);
    }
    free(solver->nodes);
    free(solver->queue);
    free(solver->hash_heads);
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
    if (solver->queue_tail >= solver->queue_capacity) {
        solver->queue_capacity *= 2;
        solver->queue = realloc(solver->queue, (size_t)solver->queue_capacity * sizeof(int));
        if (solver->queue == NULL) {
            fprintf(stderr, "Memory allocation failed.\n");
            exit(EXIT_FAILURE);
        }
    }
    solver->queue[solver->queue_tail++] = node_index;
}

static int dequeue(Solver *solver)
{
    return solver->queue[solver->queue_head++];
}

static int queue_empty(const Solver *solver)
{
    return solver->queue_head >= solver->queue_tail;
}

static int visited_contains(const Solver *solver, const int *board)
{
    int bucket = (int)(hash_board(board, solver->board_size) % (unsigned long long)solver->hash_size);
    for (int node_index = solver->hash_heads[bucket]; node_index != -1; node_index = solver->nodes[node_index].hash_next) {
        if (boards_equal(solver->nodes[node_index].board, board, solver->board_size)) {
            return 1;
        }
    }
    return 0;
}

static int add_node(Solver *solver, const int *board, int parent, int move)
{
    ensure_node_capacity(solver);

    int node_index = solver->node_count++;
    solver->nodes[node_index].board = checked_malloc((size_t)solver->board_size * sizeof(int));
    memcpy(solver->nodes[node_index].board, board, (size_t)solver->board_size * sizeof(int));
    solver->nodes[node_index].parent = parent;
    solver->nodes[node_index].move = move;

    int bucket = (int)(hash_board(board, solver->board_size) % (unsigned long long)solver->hash_size);
    solver->nodes[node_index].hash_next = solver->hash_heads[bucket];
    solver->hash_heads[bucket] = node_index;

    enqueue(solver, node_index);
    return node_index;
}

static int is_solvable(const int *board, int k)
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
    if (blank_row_from_bottom % 2 == 0) {
        return inversions % 2 == 1;
    }
    return inversions % 2 == 0;
}

static int find_blank(const int *board, int n)
{
    for (int i = 0; i < n; i++) {
        if (board[i] == 0) {
            return i;
        }
    }
    return -1;
}

static int solve_puzzle(const int *initial_board, int k, int **moves_out)
{
    int n = k * k;
    int *goal = checked_malloc((size_t)n * sizeof(int));
    for (int i = 0; i < n - 1; i++) {
        goal[i] = i + 1;
    }
    goal[n - 1] = 0;

    Solver solver;
    init_solver(&solver, n);
    add_node(&solver, initial_board, -1, -1);

    int goal_index = -1;
    const int row_change[4] = {-1, 1, 0, 0};
    const int col_change[4] = {0, 0, -1, 1};

    while (!queue_empty(&solver)) {
        int current_index = dequeue(&solver);
        int *current_board = solver.nodes[current_index].board;

        if (boards_equal(current_board, goal, n)) {
            goal_index = current_index;
            break;
        }

        int blank_index = find_blank(current_board, n);
        int blank_row = blank_index / k;
        int blank_col = blank_index % k;

        for (int d = 0; d < 4; d++) {
            int new_row = blank_row + row_change[d];
            int new_col = blank_col + col_change[d];

            if (new_row < 0 || new_row >= k || new_col < 0 || new_col >= k) {
                continue;
            }

            int tile_index = new_row * k + new_col;
            int *new_board = checked_malloc((size_t)n * sizeof(int));
            memcpy(new_board, current_board, (size_t)n * sizeof(int));
            new_board[blank_index] = new_board[tile_index];
            new_board[tile_index] = 0;

            if (!visited_contains(&solver, new_board)) {
                add_node(&solver, new_board, current_index, current_board[tile_index]);
            }
            free(new_board);
        }
    }

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

    int n = k * k;
    int *initial_board = checked_malloc((size_t)n * sizeof(int));
    for (int i = 0; i < n; i++) {
        fscanf(fp_in, "%d", &initial_board[i]);
    }
    fclose(fp_in);

    fprintf(fp_out, "#moves\n");

    if (!is_solvable(initial_board, k)) {
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
