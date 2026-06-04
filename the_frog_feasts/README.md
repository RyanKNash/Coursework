# The Frog Feasts

Arcade-style Python/Pygame game where the player controls a frog, eats flies for points, catches bonus gold flies, and avoids predators.

## Gameplay

- Move the frog around the play area.
- Eat regular flies for `+1` point.
- Catch gold flies for `+10` points.
- Stay on land or lily pads.
- Avoid the snake, fish, and heron. Contact with a predator ends the game.

## Controls

| Input | Action |
| --- | --- |
| `W`, `A`, `S`, `D` | Move the frog |
| `Space` | Start or restart |
| `Esc` | Quit |

## Requirements

- Python 3
- Pygame

Install Pygame:

```bash
pip install pygame
```

On some macOS/Linux setups:

```bash
pip3 install pygame
```

## Run

From this folder:

```bash
python main.py
```

On some systems:

```bash
python3 main.py
```

## Key Files

| File | Purpose |
| --- | --- |
| `main.py` | Main game loop and orchestration. |
| `frog.py` | Player-controlled frog. |
| `fly.py` | Regular fly behavior. |
| `gold_fly.py` | Bonus fly behavior. |
| `snake.py` | Snake predator behavior. |
| `heron.py` | Heron predator behavior. |
| `lilypad.py` | Lily pad objects/safe areas. |
| `endgame.py` | Game-over UI. |
| `text.py` | Text rendering helpers. |
| `context.py` | Screen and world settings. |
| `drawable.py` | Shared drawable base class. |

## Concepts Demonstrated

- Python game loops
- Pygame rendering and input handling
- Object-oriented game entities
- Collision detection
- Score tracking
- Basic enemy/predator behavior
- UI state transitions for start, play, and game over

## Known Issues

- The heron has a dead zone when a lily pad spawns high enough.
- The heron attacks very quickly.
- Diagonal frog movement is faster than horizontal or vertical movement.
- No high-score persistence yet.

## Notes

This was built as a CS172 coursework game. Some structure and logic were adapted from prior self-authored Python/Pygame practice projects and course-provided starter patterns.
