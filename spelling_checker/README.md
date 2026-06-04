# Spelling Checker

C spelling checker that loads a dictionary into a hash table, scans an input text file, reports misspelled words, and prints spelling suggestions.

## What It Does

- Loads dictionary words from a file.
- Stores words in a chained hash table.
- Tokenizes input text by spaces and punctuation.
- Reports words not found in the dictionary.
- Generates suggestions by:
  - adding one missing letter,
  - removing one extra letter,
  - swapping adjacent inverted letters.
- Optionally adds misspelled words to the dictionary during the run.

## Key Files

| File | Purpose |
| --- | --- |
| `main.c` | Spell checker implementation. |
| `words.txt` | Dictionary file. |
| `test.txt` | Sample input text. |
| `check`, `main.exe`, `tester.exe` | Existing compiled artifacts. |

## Build

```bash
gcc -O2 -Wall -Wextra -o check main.c
```

On Windows with GCC:

```powershell
gcc -O2 -Wall -Wextra -o check.exe .\main.c
```

## Run

```bash
./check words.txt test.txt ignore
```

To insert misspelled words into the dictionary during the current run:

```bash
./check words.txt test.txt add
```

Windows:

```powershell
.\check.exe .\words.txt .\test.txt ignore
```

## Concepts Demonstrated

- Hash tables with separate chaining
- String handling in C
- Dynamic memory allocation
- File I/O
- Tokenization with delimiters
- Suggestion generation through local word edits

## Notes

The hash table uses a fixed bucket count and a djb2-style hash. Suggestion generation is intentionally constrained to the operations required by the coursework specification.
