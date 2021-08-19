# Mitchell Merry
# 19726120
# 2021, Computer Organisation, WSU.
    .data
    .align 2
# Z is the 12 int array, k and m are the user input
Z: .word 2, 4, 7, 9, 4, 6, 1, 1, 9, 8, 3, 0, 0
k_msg: .asciiz "Enter a value for k: "
zk_msg: .asciiz "The value of Z[k] is: "
m_msg: .asciiz "\nEnter a value for m: "
zkm_msg: .asciiz "The value of Z[k+m] is: "
result_msg: .asciiz "\nZ[12] = "
    .text
    .globl main
# $s0 holds the base address of Z.
# $s1 holds 4k
# $s2 holds Z[k]
# $s3 holds 4m
# $s4 holds Z[k+m]
# $s5 holds Z[k] + Z[k+m]
# $v0, $a0 are used for syscall
# $ra, $s7 are used for return address jumping as normal
main:
    addu $s7, $0, $ra       # save the return address.
    la $s0, Z               # save the base address of Z
    
# Read values from user
    ## k

    # prompt user for value for k
    li $v0, 4               # syscall code for print_string
    la $a0, k_msg           # load prompt
    syscall                 # print
    
    # read user for value of k
    li $v0, 5               # syscall code for read_int
    syscall                 # read value from user

    # store value of Z[k] into $s2
    add $s1, $v0, $v0       # 2k
    add $s1, $s1, $s1       # 4k
    add $s2, $s0, $s1       # address of Z + 4k (Z[k])
    lw $s2, 0($s2)          # load value of Z[k] into $s1 for later use

    # print message for Z[k] value
    li $v0, 4               # syscall code for print_string
    la $a0, zk_msg          # load message for z[k] value
    syscall                 # print
    
    # print value of Z[k]
    li $v0, 1               # syscall code for print_int
    move $a0, $s2           # load Z[k]
    syscall                 # print

    ## m

    # prompt user for value for m
    li $v0, 4               # syscall code for print_string
    la $a0, m_msg           # load prompt
    syscall                 # print
    
    # read user for value of m
    li $v0, 5               # syscall code for read_int
    syscall                 # read value from user

    # store value of Z[k+m] into $s4
    add $s3, $v0, $v0       # 2m
    add $s3, $s3, $s3       # 4m
    add $s4, $s3, $s1       # 4k + 4m
    add $s4, $s0, $s4       # address of Z + (4k+4m) (Z[k+m])
    lw $s4, 0($s4)          # load value of Z[k+m] into $s4 for later use

    # print message for Z[k+m] value
    li $v0, 4               # syscall code for print_string
    la $a0, zkm_msg         # load message for z[k] value
    syscall                 # print
    
    # print value of Z[k+m]
    li $v0, 1               # syscall code for print_int
    move $a0, $s4           # load Z[k]
    syscall                 # print

# Calculate and store
    add $s5, $s2, $s4       # Z[k] + Z[k+m]
    sw $s5, 48($s0)         # Z[12] = Z[k] + Z[k+m]
    
    # print Z[12] to the screen
    li $v0, 4               # syscall code for print_string
    la $a0, result_msg      # print message for print
    syscall                 
    
    li $v0, 1               # syscall code for print_int
    lw $a0, 48($s0)         # load Z[12]
    syscall

# Usual end stuff
    addu $ra, $0, $s7       # restore return address
    jr $ra                  # return to the return address
    add $0, $0, $0          # nop
