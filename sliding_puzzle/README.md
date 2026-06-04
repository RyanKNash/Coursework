# Sliding Puzzle Solver

C implementation of a sliding tile puzzle solver. The program reads a board, checks solvability, runs breadth-first search, and writes the sequence of tile moves needed to reach the goal state.

## What It Does

- Supports `k x k` sliding puzzles.
- Validates basic input and rejects invalid tile values.
- Uses inversion counting to detect unsolvable boards before search.
- Runs BFS to find a shortest solution path.
- Tracks visited boards with a hash table and separate chaining.
- Stores parent indices so the move sequence can be reconstructed after the goal is found.
- Uses block allocation for board states to reduce per-state allocation overhead.

## Key Files

| File | Purpose |
| --- | --- |
| `main.c` | Current solver implementation. |
| `main_best.c` | Alternate/reference implementation artifact. |
| `3_easy.txt`, `3_hard.txt`, `4_medium.txt`, `4_hard.txt` | Sample puzzle inputs. |
| `*_out.txt` | Sample expected outputs. |
| `runtime.txt` | Runtime notes/artifacts from experimentation. |

## Input Format

The solver expects an input file containing:

```text
# comment/header
k
# comment/header
tile tile tile ...
```

Example for a `3 x 3` board:

```text
#k
3
#initial state
1 2 3 4 5 6 7 0 8
```

## Build

```bash
gcc -O2 -Wall -Wextra -o solve main.c
```

## Run

```bash
./solve 3_easy.txt output.txt
```

On Windows with GCC:

```powershell
gcc -O2 -Wall -Wextra -o solve.exe .\main.c
.\solve.exe .\3_easy.txt .\output.txt
```

## Output

The output file starts with:

```text
#moves
```

Then either a space-separated move list or:

```text
no solution
```

## Concepts Demonstrated

- Breadth-first search
- State-space search
- Hash-based visited sets
- Collision handling with linked chains
- Parent-pointer path reconstruction
- Manual memory management in C
- Puzzle solvability math

## Performance Notes

BFS can grow very quickly on larger puzzles. The implementation uses an FNV-1a style board hash and computes the hash table size once from `k`. Collision chains can still become expensive when the number of visited states is much larger than the bucket count, especially for `4 x 4` puzzles.
