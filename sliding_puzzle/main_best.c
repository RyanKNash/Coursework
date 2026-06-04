#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define FOUND -1

static void *checked_malloc(size_t size) {
	void *ptr = malloc(size);
	if (ptr == NULL) {
		fprintf(stderr, "Memory allocation failed\n");
		exit(EXIT_FAILURE);
	}
	return ptr;
}

static void *checked_realloc(void *ptr, size_t size)
{
    void *new_ptr = realloc(ptr, size);
    if (new_ptr == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    return new_ptr;
}

static int tile_manhattan_distance(int tile, int index, int k)
{
    int current_row = index / k;
    int current_col = index % k;
    int goal_row = (tile - 1) / k;
    int goal_col = (tile - 1) % k;
    int row_delta = current_row - goal_row;
    int col_delta = current_col - goal_col;
    return (row_delta < 0 ? -row_delta : row_delta) + (col_delta < 0 ? -col_delta : col_delta);
}

static int manhattan_distance(const unsigned char *board, int k)
{
    int distance = 0;
    int n = k * k;

    for (int i = 0; i < n; i++) {
        int tile = board[i];
        if (tile == 0) {
            continue;
        }

        distance += tile_manhattan_distance(tile, i, k);
    }

    return distance;
}

static int is_goal(const unsigned char *board, int n)
{
    for (int i = 0; i < n - 1; i++) {
        if (board[i] != i + 1) {
            return 0;
        }
    }
    return board[n - 1] == 0;
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
    if (blank_row_from_bottom % 2 == 0) {
        return inversions % 2 == 1;
    }
    return inversions % 2 == 0;
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

static int ida_search(unsigned char *board, int k, int n, int blank_index, int depth,
                      int limit, int manhattan, int previous_direction, int *moves)
{
    int estimate = depth + manhattan;
    if (estimate > limit) {
        return estimate;
    }
    if (manhattan == 0 && is_goal(board, n)) {
        return FOUND;
    }

    const int row_change[4] = {-1, 1, 0, 0};
    const int col_change[4] = {0, 0, -1, 1};
    const int opposite_direction[4] = {1, 0, 3, 2};
    int blank_row = blank_index / k;
    int blank_col = blank_index % k;
    int next_limit = INT_MAX;

    for (int d = 0; d < 4; d++) {
        if (previous_direction != -1 && d == opposite_direction[previous_direction]) {
            continue;
        }

        int new_row = blank_row + row_change[d];
        int new_col = blank_col + col_change[d];
        if (new_row < 0 || new_row >= k || new_col < 0 || new_col >= k) {
            continue;
        }

        int tile_index = new_row * k + new_col;
        int moved_tile = board[tile_index];
        int new_manhattan = manhattan
            - tile_manhattan_distance(moved_tile, tile_index, k)
            + tile_manhattan_distance(moved_tile, blank_index, k);

        board[blank_index] = (unsigned char)moved_tile;
        board[tile_index] = 0;
        moves[depth] = moved_tile;

        int result = ida_search(board, k, n, tile_index, depth + 1, limit,
                                new_manhattan, d, moves);

        board[tile_index] = (unsigned char)moved_tile;
        board[blank_index] = 0;

        if (result == FOUND) {
            return FOUND;
        }
        if (result < next_limit) {
            next_limit = result;
        }
    }

    return next_limit;
}

static int solve_puzzle(const unsigned char *initial_board, int k, int **moves_out)
{
    int n = k * k;
    unsigned char *board = checked_malloc((size_t)n * sizeof(unsigned char));
    for (int i = 0; i < n; i++) {
        board[i] = initial_board[i];
    }

    int blank_index = find_blank(board, n);
    int limit = manhattan_distance(board, k);
    int move_capacity = limit + 1;
    if (move_capacity < 1) {
        move_capacity = 1;
    }
    int *moves = checked_malloc((size_t)move_capacity * sizeof(int));

    while (1) {
        if (limit + 1 > move_capacity) {
            move_capacity = limit + 1;
            moves = checked_realloc(moves, (size_t)move_capacity * sizeof(int));
        }

        int result = ida_search(board, k, n, blank_index, 0, limit,
                                manhattan_distance(board, k), -1, moves);
        if (result == FOUND) {
            free(board);
            *moves_out = moves;
            return limit;
        }
        if (result == INT_MAX) {
            free(board);
            free(moves);
            *moves_out = NULL;
            return -1;
        }
        limit = result;
    }
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
    unsigned char *initial_board = checked_malloc((size_t)n * sizeof(unsigned char));
    for (int i = 0; i < n; i++) {
        int tile;
        fscanf(fp_in, "%d", &tile);
        initial_board[i] = (unsigned char)tile;
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
