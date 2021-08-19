# Mitchell Merry
# 19726120
# 2021, Computer Organisation, WSU.
    .data
    .align 2
# Z is the 10 int array, X is the store for the value after calculation
Z: .word 2, 4, 7, 9, 4, 6, 1, 1, 9, 8
X: .word 0
    .text
    .globl main
# $s0 holds the base address of Z.
# $t0-$t2 are used for calculation.
# $v0, $a0 are used for syscall
# $ra, $s7 are used for return address jumping as normal
main:
    addu $s7, $0, $ra       # save the return address.

    la $s0, Z               # save the base address of Z

    lw $t0, 12($s0)         # get the value of Z[3]
    lw $t1, 20($s0)         # get the value of Z[5]
    sub $t2, $t0, $t1       # perform Z[3]-Z[5]
    sw $t2, X               # X = Z[3] - Z[5] (store result in memory)

    li $v0, 1               # syscall code for print_int
    move $a0, $t2           # pass X into syscall for printing
    syscall                 # print X
    
# Usual end stuff
    addu $ra, $0, $s7       # restore return address
    jr $ra                  # return to the return address
    add $0, $0, $0          # nop
