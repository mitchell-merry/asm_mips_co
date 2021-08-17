    .data
jumptable: .word 0, 0, 0, 0
    .text
    .globl main
main:
    addu $s7, $0, $ra       # save the return address.

# Initialise values:
    li $s0, 0               # f = 0
    
    li $s1, 5               # g = 5
    li $s2, -20             # h = -20
    li $s3, 13              # i = 13
    li $s4, 3               # j = 3

    li $s5, 2               # k = 2

    li $t2, 4               # 4 cases
    la $t4, jumptable       # base address of jumptable

# Load addresses into memory:
    la $t0, L0
    sw $t0, 0($t4)
    la $t0, L1
    sw $t0, 4($t4)
    la $t0, L2
    sw $t0, 8($t4)
    la $t0, L3
    sw $t0, 12($t4)

# The switch statement itself:
    add $s6, $s5, $s5
    add $s6, $s6, $s6       # 4*k
    add $s6, $s6, $t4       # jumptable[k] - address of the address in memory (lol) 
    lw $s6, 0($s6)          # load the address to jump to to register $s6
    jr $s6                  # jump to the address

L0: add $s0, $s3, $s4
    j Exit
L1: add $s0, $s1, $s2
    j Exit
L2: sub $s0, $s1, $s2
    j Exit
L3: sub $s0, $s3, $s4
Exit:

    addu $ra, $0, $s7       # restore return address
    jr $ra                  # return to the return address
    add $0, $0, $0          # nop