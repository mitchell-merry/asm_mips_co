# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 05

    .data
    .align 2
P: .space 36
Q: .space 36
prompt: .asciiz "\nPlease enter a length N between 1 and 9: "   # We say please but don't enforce it
p_print_msg: .asciiz "\nContents of P: "
q_print_msg: .asciiz "\nContents of Q: "
    .text
    .globl main
# Registers:
# $s0 holds the value for N.
# $s1,$s2 hold the base addresses for P and Q respectively
# $v0, $a0 are used for syscall
# $ra, $s7 are used for return address jumping as normal
main:
    addu $s7, $0, $ra           # save the return address

    # Store the base addresses of P and Q into $s1,$s2
    la $s1, P
    la $s2, Q

    # Read the value for N.
    li $v0, 4                   # syscall code for print_string
    la $a0, prompt              # print the prompt
    syscall

    li $v0, 5                   # syscall code for read_int
    syscall                     # take in the value of N to $v0
    move $s0, $v0               # store the value of N in register $s0

    # Initialise the arrays
    move $a0, $s0               # Pass in length, P, and Q as arguments
    move $a1, $s1
    move $a2, $s2
    jal init_arrays
    nop
    
    # Print P
    li $v0, 4                   # print_str syscall code
    la $a0, p_print_msg
    syscall
    move $a0, $s0               # Pass in length, P as arguments
    move $a1, $s1
    jal print_array
    nop
    
    # Print Q
    li $v0, 4                   # print_str syscall code
    la $a0, q_print_msg
    syscall
    move $a0, $s0               # Pass in length, Q as arguments
    move $a1, $s2
    jal print_array
    nop

    j Exit

# Precondition:     $a0 - number of values to be read
#                   $a1 - base address of array 1
#                   $a2 - base address of array 2
# Postcondition:    Both arrays will be initialised for the first $a0 elements according to user input.
#
#   $t0 - length
#   $t1 - base address of array 1
#   $t2 - base address of array 2
#   $t3 - counter
#   $t4 - address of P[i]
#   $t5 - address of Q[i]
#
init_arrays:
    # Load arguments into $t0-$t2 for safekeeping
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2

    li $t3, 0                   # initialise counter to 0

ia_inner:

    # Get addresses for P[i] and Q[i]
    add $t4, $t3, $t3
    add $t4, $t4, $t4           # 4i
    add $t5, $a2, $t4           # Q + 4i - address of Q[i] in $t5
    add $t4, $a1, $t4           # P + 4i - address of P[i] in $t4

    # Read value from user
    li $v0, 5                   # syscall code for read_int
    syscall                     # take in the value of N to $v0

    # Store value in P[i] and Q[i]
    sw $v0, 0($t4)              # P[i] = user input
    sw $v0, 0($t5)              # Q[i] = user input

    addi $t3, $t3, 1            # increment counter
    bne $t3, $t0, ia_inner      # loop if counter hasn't reached max

    # Exit function
    jr $ra

# Precondition:     $a0 - number of values to be read
#                   $a1 - base address of the array
#
#   $t0 - length
#   $t1 - base address of array
#   $t2 - pointer counter
#   $t3 - end pointer
#
print_array:
    # Load arguments into $t0-$t1 for safekeeping
    move $t0, $a0
    move $t1, $a1

    move $t2, $t1               # initialise counter to base address of array
    add $t3, $t0, $t0
    add $t3, $t3, $t3           # 4n
    add $t3, $t1, $t3           # initialise max pointer (A+4n)

    
pa_inner:
    li $v0, 1                   # syscall code for print_int
    lw $a0, 0($t2)              # Prepare element for printing
    syscall                     # print

    li $v0, 11
    li $a0, 0x2c
    syscall

    addi $t2, $t2, 4            # increment pointer to byte
    bne $t3, $t2, pa_inner      # loop if counter hasn't reached max

    # Exit function
    jr $ra


Exit:
    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra                      # exit program
    nop