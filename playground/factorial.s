    .data
number: .word 5                     # argument to pass in for factorial
    .text
    .globl main
main:
    addu $s7, $0, $ra               # save the return address.

    lw $a0, number                  # pass argument into factorial

    jal factorial                   # perform factorial
    nop

    move $s0, $v0                   # save the result in $s0

    li $v0, 1                       # print_int
    move $a0, $s0                   # printing result
    syscall                         # syscall

    addu $ra, $0, $s7               # restore return address
    jr $ra                          # return to the return address
    add $0, $0, $0                  # nop

#   Precondition:       $a0 - number to factorial
#   Postcondition:      $v0 - result of factorial
#           Returns 1 if $a0 is <= 1. Returns $a0! otherwise.   
#
#   Pseudocode:
#   int factorial(int num) {
#       if(num <= 1) return 1;
#       return num*factorial(num-1);
#   }
factorial:
    # Push the return address and argument onto the stack
    addi $sp, $sp, -8
    sw $a0, 4($sp)
    sw $ra, 0($sp)

    # Return if the number passed is less than or equal to 1
    slti $t0, $a0, 2                # $a0 <= 1
    li $t1, 1                       # true (1)
    li $v0, 1                       # return 1
    beq $t0, $t1, factorial_exit    # if ($a0 <= 1) is true, exit function

    # Otherwise, we recurse.
    addi $a0, $a0, -1               # pass in (number - 1)
    jal factorial                   # we recurse
    nop
    addi $a0, $a0, 1                # undo subtraction
    mul $v0, $a0, $v0               # return number * f(number - 1)

factorial_exit:
    # Restoring values for the caller from the stack
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8

    jr $ra