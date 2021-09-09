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

# Calculates the $a0th fibonacci number.
# Precondition:     $a0 - n
# Postcondition:    $v0 - the nth fibonacci number.
fib:
    li $t0, 2                   # counter
    li $t1, 0                   # $t1 will be used to store the F(n-2)th number.
    li $t2, 1                   # $t2 will be Fn-1. They get initialised to 0 and 1 as F0=0 and F1=1
fib_loop:
    add $t3, $t1, $t2           # Fnth number
    beq $t0, $a0, fib_exit      # if we've just calculated the final fib number, exit the loop

    # Prepare for next loop by updating the Fn-2th and Fn-1th numbers ($t1 and $t2)
    move $t1, $t2
    move $t2, $t3

    addi $t0, $t0, 1            # increment counter and loop
    j fib_loop
    nop

fib_exit:
    move $v0, $t3               # store result in $v0
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