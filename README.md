# Coursework Portfolio

This repository collects coursework projects from data structures, systems programming, algorithms, functional programming, computer architecture, game development, and test-driven Java development. The projects are intentionally small and focused, but together they show practical experience with C memory management, hash tables, linked lists, graph search, tree data structures, Python object modeling, Racket recursion, RISC-V assembly, Pygame, Java unit testing, Gradle, and CI-oriented quality tooling.

## Projects

| Project | Language | Focus |
| --- | --- | --- |
| [sliding_puzzle](sliding_puzzle/) | C | Breadth-first search solver for sliding tile puzzles, solvability checks, hash-based visited-state tracking, and memory-conscious board storage. |
| [spelling_checker](spelling_checker/) | C | Dictionary-backed spell checker using a chained hash table and edit-distance-style suggestion generation. |
| [grade_extractor](grade_extractor/) | C | Command-line grade database tool with parsing, validation, linked-list storage, stats, and file persistence. |
| [tdd_bank_account](tdd_bank_account/) | Java | Test-driven banking command processor with accounts, validation, transfers, monthly APR behavior, JUnit tests, JaCoCo, PIT, Gradle, and CI config. |
| [the_frog_feasts](the_frog_feasts/) | Python | Pygame arcade game with player movement, scoring, collision detection, enemies, and game-over flow. |
| [commencement](commencement/) | Python | Graduation ceremony simulation using queues, priority queues, stacks, inheritance, and a linked-list photo manifest. |
| [bst](bst/) | Python | Simple binary search tree lab comparing average search length against linear list search. |
| [racket](racket/) | Racket | Functional programming assignments covering recursion, Peano arithmetic, SAT/truth-table foundations, and induction proofs. |
| [RISC-V](RISC-V/) | RISC-V Assembly | Assembly labs covering recursion, stack usage, LED/button I/O, seven-segment displays, and counter control. |
| [huffman_coder](huffman_coder/) | C | Huffman coding assignment materials and sample input/output artifacts for text compression and decompression. |

## Technical Highlights

- Implemented hash tables in C with separate chaining for dictionary lookup and visited-state detection.
- Built C command-line tools that parse structured files, validate input, mutate records, and persist updates safely.
- Built a BFS search over puzzle states with compact board storage and parent-pointer move reconstruction.
- Practiced manual memory allocation, dynamic arrays, linked structures, and explicit cleanup in C.
- Designed object-oriented Python models using inheritance and abstract base classes.
- Implemented a binary search tree and compared search behavior against linear list search.
- Completed Racket assignments emphasizing recursion, symbolic representations, unit tests, and mathematical proof techniques.
- Wrote RISC-V assembly programs using stack frames, branches, subroutines, lookup tables, and simulator I/O.
- Built a Python/Pygame arcade game with interactive movement, collisions, scoring, and multiple entity types.
- Developed a Java banking command system using TDD, validator/processor separation, and comprehensive JUnit coverage.
- Configured Gradle quality tooling, including JaCoCo coverage reporting and PIT mutation testing.

## Repository Structure

```text
coursework/
  bst/                Python binary search tree comparison lab
  commencement/       Python ceremony simulation
  huffman_coder/      C Huffman coding assignment assets
  grade_extractor/    C grade database CLI
  racket/             Racket functional programming assignments
  RISC-V/             RISC-V assembly labs
  sliding_puzzle/     C sliding puzzle solver
  spelling_checker/   C hash-table spell checker
  tdd_bank_account/   Java TDD banking project
  the_frog_feasts/    Python/Pygame arcade game
```

## Build And Run

Each project folder has its own README with project-specific commands. In general:

- C projects can be compiled with `gcc` or another C compiler.
- Python projects can be run with `python`; `the_frog_feasts` also requires Pygame.
- Racket assignments can be run with the `racket` command.
- RISC-V assembly files are intended for the course simulator environment.
- The Java project uses the included Gradle wrapper.

## Recruiter Notes

This repository is best read as a progression of coursework artifacts rather than a single production application. The strongest engineering examples are `tdd_bank_account`, `sliding_puzzle`, and `spelling_checker`, which show testing discipline, algorithmic reasoning, and low-level implementation work.
