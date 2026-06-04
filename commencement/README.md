# Commencement Ceremony Simulator

Python project that models a university commencement ceremony using object-oriented design and standard data structures.

## What It Does

- Represents participants as `Graduate`, `Faculty`, and `Guest` objects.
- Uses an abstract `Participant` base class for shared name behavior.
- Manages speakers with a `PriorityQueue`.
- Separates graduate and undergraduate walking order with FIFO queues.
- Tracks stage party recessional order with a LIFO stack.
- Builds a photo manifest with a linked list.
- Generates program text and announcer cards.

## Key Files

| File | Purpose |
| --- | --- |
| `HW05.py` | Demo/test driver that creates sample participants and simulates a ceremony. |
| `graduation.py` | Core `GraduationCeremony` class and queue/stack/list coordination. |
| `participants.py` | Participant hierarchy for graduates, faculty, and guests. |
| `linkedlist.py` | Linked list implementation used for the photo manifest. |

## Run

```bash
python HW05.py
```

On Windows, depending on your Python installation:

```powershell
python .\HW05.py
```

## Concepts Demonstrated

- Object-oriented design
- Abstract base classes
- Encapsulation with private fields
- Queues, priority queues, stacks, and linked lists
- Sorting and formatted text generation

## Notes

The included driver uses randomly generated sample data, so output order and participant names may vary between runs.
