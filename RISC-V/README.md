# RISC-V Assembly Labs

Collection of RISC-V assembly programs for arithmetic, stack usage, subroutines, memory-mapped I/O, LEDs, push buttons, and seven-segment display control.

## Project Focus

These files show low-level programming fundamentals:

- Register-level arithmetic and branching
- Recursive function calls and stack-frame management
- Subroutine design with `jal`, `ret`, and saved registers
- Memory-mapped simulator I/O through `ecall`
- LED output control
- Push-button input handling
- Seven-segment display encoding
- Counter bounds checking and error feedback

## Files

| File | Purpose |
| --- | --- |
| `recursive_multiplication.s` | Recursive multiplication implemented with repeated addition and explicit stack/return-address handling. |
| `alternating_led_blink.s` | Alternates LED states with a delay loop. |
| `button_controlled_led.s` | Reads button input and mirrors it to LED output. |
| `double_led_flash.s` | Reusable subroutine that flashes both LEDs twice with delay timing. |
| `two_digit_display_counter.s` | Counts from `0` to `99`, converts values to BCD, and writes two digits to a seven-segment display. |
| `interactive_counter_display.s` | Completed counter/display lab: buttons increment/decrement a bounded counter, updates the display, sets LEDs based on odd/even/power-of-two state, and flashes on boundary errors. |

## Running

These programs are written for a RISC-V educational environment with simulator-specific `ecall` services for:

- Seven-segment display output: `0x120`
- LED output: `0x121`
- Button input: `0x122`

They are intended to run in the course simulator environment, such as Venus configured for the lab's microcontroller I/O extensions.

## Example Workflow

Open one `.s` file in the RISC-V simulator, assemble it, and run from `main`.

For the most complete demo, start with:

```text
interactive_counter_display.s
```

## Concepts Demonstrated

- RISC-V calling convention basics
- Stack allocation and register preservation
- Branching and loop construction
- Recursive assembly routines
- Lookup tables in `.data`
- Integer division and remainder for digit extraction
- Bit masks and bitwise operations
- Hardware-style I/O programming

## Naming Notes

The files have been renamed from assignment-style names to recruiter-friendly names that describe the behavior of each program.
