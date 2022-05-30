# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 09

    .data
buffer: .space 6
msg: .asciiz "Start entering characters (buffer size 6):\n"
    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address

    li  $v0, 4                  # print_str
    la  $a0, msg                # print message indicating buffer size / instruction
    syscall

    li $s0, 0                   # character counter
    li $s1, 6                   # max character count
    la $s2, buffer              # address of buffer to write to

    lui $s3, 0xffff             # receiver control register address

# Read characters into buffer
main_rl: # main read loop
    # Check if ready
    lw $t1, 0($s3)              # load receiver control   
    andi $t1, $t1, 0x0001       # mask to get just the last bit, the ready flag
    beq $t1, $0, main_rl        # if not ready, wait

    # Load received data
    lb $t2, 4($s3)              # load the receieved character at 0xffff0004
    add $t1, $s2, $s0           # address to store buffer at
    sb $t2, 0($t1)              # store character at address in memory

    # Check buffer size and loop if there's room
    addi $s0, $s0, 1            # increment current character by 1
    bne $s0, $s1, main_rl       # keep looping if max size not reached

    li $s0, 0                   # reset loop count

main_wl: # main write loop

    # Check if ready
    lw $t1, 8($s3)              # load transmitter control
    andi $t1, $t1, 0x1          # mask to get the last bit, the ready flag
    beq $t1, $t0, main_wl       # if not ready, wait

    # Transmit data
    add $t1, $s2, $s0           # address to load buffer from
    lb $t2, 0($t1)              # load character at address
    sb $t2, 12($s3)             # transmit current character

    # Check buffer size and loop if there's more to go
    addi $s0, $s0, 1            # increment current char by 1
    bne $s0, $s1, main_wl       # keep looping if max not reached

    j Exit


Exit:
    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop