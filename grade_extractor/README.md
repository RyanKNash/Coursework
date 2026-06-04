# Grade Extractor

C command-line grade database tool that loads a colon-delimited grade file, accepts commands from standard input, and saves updates back to disk.

## What It Does

- Loads grade records from a database file.
- Validates student IDs, assignment names, and grade values.
- Stores records in a linked list while the program runs.
- Prints all grade entries in a formatted table.
- Adds new grade records.
- Removes existing grade records.
- Computes min, max, and mean for a selected assignment.
- Writes the updated database back to the original file using a temporary file and rename.

## Data Format

Each database line uses:

```text
student_id:assignment_name:grade
```

Example:

```text
9991912292:HW 3:100
2145902184:HW 1:45
```

Validation rules:

- Student ID must be exactly 10 digits.
- Assignment name must be 1 to 20 characters.
- Assignment name cannot contain `:`.
- Grade must be an integer from `0` to `100`.
- Duplicate `student_id + assignment_name` entries are rejected.

## Commands

After starting the program, type commands through standard input:

| Command | Purpose |
| --- | --- |
| `print` | Print every grade entry. |
| `add <student_id>:<assignment_name>:<grade>` | Add a new grade entry. |
| `remove <student_id>:<assignment_name>` | Remove an existing entry. |
| `stats <assignment_name>` | Print min, max, and mean for an assignment. |

End input with `Ctrl+D` on macOS/Linux or `Ctrl+Z` then Enter on Windows.

## Build

```bash
make
```

Equivalent direct compiler command:

```bash
gcc -Wall -Wextra -Werror -std=c11 -pedantic -o grades grades.c
```

## Run

```bash
./grades db
```

Example interactive session:

```text
print
stats HW 1
add 1234567890:Quiz 1:95
remove 2145902184:HW 1
```

## Key Files

| File | Purpose |
| --- | --- |
| `grades.c` | Main implementation for parsing, validation, command handling, linked-list storage, and database saving. |
| `Makefile` | Build and clean targets. |
| `db` | Sample grade database. |

## Concepts Demonstrated

- C file I/O
- Command-line argument validation
- Standard input command processing
- Linked-list storage
- Defensive parsing and input validation
- Temporary-file save strategy
- Manual memory management
