# Lab 3 – IoT / RISC-V Venus Microcontroller
# Extra credit features are included.

.data
                   #76543210
digits:     .word 0b00111111   # 0
            .word 0b00000110   # 1
            .word 0b01011011   # 2
            .word 0b01001111   # 3
            .word 0b01100110   # 4
            .word 0b01101101   # 5
            .word 0b01111101   # 6
            .word 0b00000111   # 7
            .word 0b01111111   # 8
            .word 0b01100111   # 9

digit_msk:  .word 0b111111111111111
digit_max:  .word 100
digits_sz:  .word 10

.text

# Button states
.equ LEFT_PRESS,  0b10
.equ RIGHT_PRESS, 0b01
.equ NO_PRESS,    0b00

# Counter bounds
.equ MIN_VAL,     0
.equ MAX_VAL,     99

# LED bit masks
.equ LED_RED,     0b01
.equ LED_GREEN,   0b10
.equ LED_BOTH,    0b11

.globl main

# --------------------------------------------------
# MAIN
# --------------------------------------------------
main:
    # initialize counter to 0 and display "00"
    li s0, 0
    mv a0, s0
    jal write_lcd

    # also initialize LEDs (0 is even → green LED)
    mv a0, s0
    jal update_leds

# infinite loop
loop:
    # read push button state (ecall 0x122)
    li a0, 0x122
    ecall

    # call adjust_counter(button_state, current_value)
    mv a1, s0
    jal adjust_counter

    # store returned counter value
    mv s0, a0

    j loop

    ret


# --------------------------------------------------
# adjust_counter
# a0 = button state
# a1 = current counter
# returns updated counter in a0
# --------------------------------------------------
adjust_counter:
    addi sp, sp, -8
    sw s0, 4(sp)
    sw ra, 0(sp)

    mv s0, a1   # store current value in s0

    # if no button pressed → do nothing
    li t0, NO_PRESS
    beq a0, t0, exit_adj_counter

    # LEFT button → increment
    li t0, LEFT_PRESS
    beq a0, t0, inc_counter

    # RIGHT button → decrement
    li t0, RIGHT_PRESS
    beq a0, t0, dec_counter

    # any other case → ignore
    j exit_adj_counter


# ------------------------
# decrement counter
# ------------------------
dec_counter:
    li t0, MIN_VAL
    beq s0, t0, err_counter   # cannot go below 0

    addi s0, s0, -1

    # update display
    mv a0, s0
    jal write_lcd

    # update LEDs
    mv a0, s0
    jal update_leds

    j exit_adj_counter


# ------------------------
# increment counter
# ------------------------
inc_counter:
    li t0, MAX_VAL
    beq s0, t0, err_counter   # cannot go above 99

    addi s0, s0, 1

    # update display
    mv a0, s0
    jal write_lcd

    # update LEDs
    mv a0, s0
    jal update_leds

    j exit_adj_counter


# ------------------------
# error case (boundary hit)
# ------------------------
err_counter:
    # Extra Credit 1:
    # flash LEDs 5 times instead of hard-coded value
    li a0, 5
    jal flash_led

    # restore LED state based on current value
    mv a0, s0
    jal update_leds


# restore registers and return
exit_adj_counter:
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret


# --------------------------------------------------
# write_lcd
# converts integer → two 7-segment digits
# --------------------------------------------------
write_lcd:
    addi sp, sp, -4
    sw ra, 0(sp)

    # break number into tens and ones
    jal extract_bcd

    # convert digits into segment encoding
    jal encode_digit

    mv a1, a0   # final encoded value for display

    # load mask
    la t0, digit_msk
    lw a2, 0(t0)

    # send to display (ecall 0x120)
    li a0, 0x120
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


# --------------------------------------------------
# extract_bcd
# splits number into tens and ones
# --------------------------------------------------
extract_bcd:
    mv t0, a0
    li t1, 10

    div t2, t0, t1   # tens
    rem t3, t0, t1   # ones

    mv a0, t2
    mv a1, t3
    ret


# --------------------------------------------------
# encode_digit
# converts digits into 7-segment bit patterns
# --------------------------------------------------
encode_digit:
    la t0, digits

    slli a0, a0, 2
    slli a1, a1, 2

    add t1, t0, a0
    add t2, t0, a1

    lw a0, 0(t1)
    lw a1, 0(t2)

    # combine into one 16-bit value
    slli a0, a0, 8
    or a0, a0, a1

    ret


# --------------------------------------------------
# update_leds
# Extra Credit 2 + 3
# --------------------------------------------------
update_leds:
    addi sp, sp, -4
    sw ra, 0(sp)

    mv t0, a0

    # -------- Power of 2 check (Extra Credit 3) --------
    # if number is 0 → not power of 2
    beqz t0, check_odd_even

    addi t1, t0, -1
    and  t2, t0, t1

    # if result == 0 → power of 2
    bnez t2, check_odd_even

    li a0, 0x121
    li a1, LED_BOTH
    ecall
    j done_leds


# -------- Odd/Even check (Extra Credit 2) --------
check_odd_even:
    andi t1, t0, 1   # isolate LSB

    # if LSB = 0 → even
    beqz t1, set_green

# odd → red
set_red:
    li a0, 0x121
    li a1, LED_RED
    ecall
    j done_leds

# even → green
set_green:
    li a0, 0x121
    li a1, LED_GREEN
    ecall

done_leds:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


# --------------------------------------------------
# flash_led
# Extra Credit 1
# blinks both LEDs a0 times
# --------------------------------------------------
flash_led:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    li s0, 0
    mv s1, a0   # number of blinks

flash_loop:
    beq s0, s1, flash_done
    addi s0, s0, 1

    # LEDs ON
    li a0, 0x121
    li a1, LED_BOTH
    ecall

    li a0, 250
    jal sleep

    # LEDs OFF
    li a0, 0x121
    li a1, 0b00
    ecall

    li a0, 250
    jal sleep

    j flash_loop

flash_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret


# --------------------------------------------------
# sleep
# simple delay loop
# --------------------------------------------------
sleep:
    mv t0, a0

sleep_loop:
    addi t0, t0, -1
    bnez t0, sleep_loop

    ret
