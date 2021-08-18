    .data
x: .asciiz "copy m"                # string to copy
y: .asciiz "      "                # string to copy to

    .text
    .globl main
main:
    addu $s7, $0, $ra               # save the return address.

    # Initialise values
    la $a0, x
    la $a1, y                       # base address of arrays in memory
    li $s0, 0                       # counter

loop:
    add $t0, $a0, $s0               # address of x[i] in memory, the byte, not the word
    lb $t1, 0($t0)                  # load next byte/character into $t1
    
    beq $t1, $0, exit               # if character is a NUL byte, exit loop 
    
    add $t2, $a1, $s0               # address of y[i] in memory
    sb $t1, 0($t2)                  # copy x[i] into y[i], i.e., y[i] = x[i]

    addi $s0, $s0, 1                # increment counter i
    j loop                          # loop

exit:
    addu $ra, $0, $s7
    jr $ra
    nop