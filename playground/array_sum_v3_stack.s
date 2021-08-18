    .data
A:      .word 0, 5, -20, 13, 3
size:   .word 5    
    
    .text
    .globl main
main:
    addu $s7, $0, $ra       # save the return address.

    la $a0, A               # array address
    lw $a1, size            # array size

    jal sum                 # calculate sum
    nop

    move $s0, $v0           # move the result of the sum to $s0
    
    li $v0, 1               # print_int
    move $a0, $s0           # print the sum
    syscall                 # syscall

    addu $ra, $0, $s7       # restore return address
    jr $ra                  # return to the return address
    add $0, $0, $0          # nop

# Precondition:     $a0 - base array address.
#                   $a1 - array size.
# Postcondition:    $v0 - sum of the array.
sum:
    # Save caller values in stack - doesn't technically follow conventions to save $t registers, but for practice.
    addi $sp, $sp, -12
    sw $t0, 8($sp)
    sw $t1, 4($sp)
    sw $t3, 0($sp)

    add $t0, $a1, $a1
    add $t0, $t0, $t0       # 4x the size of the array
    add $t0, $a0, $t0       # final array pointer (array base + 4*size)
    add $t1, $a0, $0        # array element pointer (array base)
    li  $v0, 0              # store result

loop:
    beq $t0, $t1, sum_exit       # if the pointer reaches max, exit loop

    lw  $t3, 0($t1)         # load value at pointer

    add $v0, $v0, $t3       # sum next array element

    addi $t1, $t1, 4        # increment pointer
    j loop                  # loop

sum_exit:
    # Restore values for the caller from the stack
    lw $t3, 0($sp)
    lw $t1, 4($sp)
    lw $t0, 8($sp)
    addi $sp, $sp, 12

    jr $ra