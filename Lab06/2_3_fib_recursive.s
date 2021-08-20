# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 06

    .data
    .align 2
prompt: .asciiz "Enter a value between 2 and 45: "
rib_error: .asciiz "Your value does not fit the range. Exiting..."
fib_msg_1: .asciiz "Element ["
fib_msg_2: .asciiz "] of Fibonacci string is: "
    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address

    li $a0, 2
    li $a1, 45                  # min-max is 2-45
    jal read_int_between        # call function
    nop
    move $s0, $v0               # save n into $s0
    
    move $a0, $v0               # pass user input into function
    jal fib                     # calculate number
    nop
    move $s1, $v0               # save Fn into $s1, the result

##### Print result
    li $v0, 4                   # syscall code for print_str
    la $a0, fib_msg_1
    syscall

    li $v0, 1                   # syscall code for print_int
    move $a0, $s0               # print n
    syscall

    li $v0, 4                   # syscall code for print_str
    la $a0, fib_msg_2           
    syscall

    li $v0, 1                   # syscall code for print_int
    move $a0, $s1               # print Fn
    syscall

    j Exit
    nop

# Calculates the $a0th fibonacci number, recursively.
# Precondition:     $a0 - n
# Postcondition:    $v0 - the nth fibonacci number.
fib:
    # Save to the stack
    addi $sp, $sp, -12
    sw $s0, 8($sp)              # save s0 (preserved between calls)
    sw $a0, 4($sp)              # save the argument
    sw $ra, 0($sp)              # save return address

    # Return n if n is <= 1 (undefined for n < 0)
    sle $t0, $a0, 1             # n <= 1?
    li $t1, 1                   # true value
    move $v0, $a0               # return n if true
    beq $t0, $t1, fib_exit      # if n<=1 is true return n

    # Calculate Fn-1
    addi $a0, $a0, -1           # pass n-1
    jal fib                     # calculate fn-1
    nop 
    move $s0, $v0               # store result in $s0
                                # (gets preserved between calls)
    
    # Calculate Fn-2
    addi $a0, $a0, -1           # pass n-2
    jal fib                     # calculate fn-2
    nop
    move $t1, $v0               # store result in $t1
    
    add $v0, $s0, $t1           # Fn = Fn-1 + Fn-2

    nop

fib_exit:
    # Restoring values for the caller from the stack
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $s0, 8($sp)
    addi $sp, $sp, 12
    
    jr $ra
    nop

# Ensures valid user input between [$a0, $a1]. Exits on fail.
# Note: previously this function was used to loop until correct
# input, hence the rib_loop label.
# Precondition:     $a0 - minimum value
#                   $a1 - maximum value
# Postcondition:    $v0 - value from the user
read_int_between:
    move $t0, $a0               # save minimum in $t0 (otherwise it gets overwritten)
    move $t1, $a1               # save maximum in $t1 (for conformity)

#rib_loop:
    li $v0, 4                   # syscall code for print_string
    la $a0, prompt              # print the prompt
    syscall

    li $v0, 5                   # syscall code for read_int
    syscall                     # take in the value of N to $v0

    sle $t2, $t0, $v0           # $t2 = 1 <= N
    sle $t3, $v0, $t1           # $t3 = N <= 9
    bne $t2, $t3, rib_exit      # exit if both are not true. They cannot both be simultaneously false
                                # so this guarantees that 1 <= N <= 9

    move $a0, $t0               # restore $a0
    move $a1, $t1               # restore $a1 (not necessary)
    jr $ra
    nop

rib_exit:
    li $v0, 4                   # syscall code for print_string
    la $a0, rib_error           # print the error message
    syscall

    j Exit
    nop

Exit:
    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop