# Binary Search Tree

Simple Python binary search tree lab that compares search length in a shuffled list versus a binary search tree built from the same values.

## What It Does

- Generates shuffled integer lists.
- Inserts list values into a binary search tree.
- Searches for each value in both the list and BST.
- Computes average search length for each structure.
- Prints comparison results across increasing input sizes.

## Key Files

| File | Purpose |
| --- | --- |
| `BST.py` | `Node` and `BST` classes with insertion, containment checks, and search-length measurement. |
| `main.py` | Driver that builds randomized lists/trees and compares average search lengths. |

## Run

```bash
python main.py
```

On some systems:

```bash
python3 main.py
```

## Concepts Demonstrated

- Binary search tree insertion
- Tree traversal for search
- Python special methods such as `__contains__` and `__str__`
- Empirical comparison of linear search and tree search
- Randomized input generation

## Notes

This BST is intentionally simple and unbalanced. Search performance depends on insertion order; shuffled input usually produces better tree shape than sorted input, but it does not guarantee balance.
