    .data
A:      .word 0, 5, -20, 13, 3
size:   .word 5    
    
    .text
    .globl main
main:
    addu $s7, $0, $ra # save the return address.

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
    add $t0, $a1, $a1
    add $t0, $t0, $t0       # mulitply array size by 4 and store in $t0
    
    li $t1, 0               # loop counter
    li $t2, 0               # store result

loop:
    beq $t0, $t1, sum_exit  # if the loop counter reaches max, exit loop

    add $t3, $a0, $t1       # memory address of the index stored in t3
    lw $t3, 0($t3)
    add $t2, $t2, $t3       # sum next array element

    addi $t1, $t1, 4        # increment loop counter
    j loop                  # loop

sum_exit:
    add $v0, $t2, 0         # store result in $v0
    jr $ra                  # return to main program