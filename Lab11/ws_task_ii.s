# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 11

    .data
    .align 2
gi_prompt_a: .asciiz "Input a 0 or 1 for a:"
gi_prompt_b: .asciiz "\nInput a 0 or 1 for b:"
gi_prompt_c: .asciiz "\nInput a 0 or 1 for CarryIn:"
gi_err_msg: .asciiz "\nInvalid input. Terminating..\n"

result: .asciiz "\nCarryOut is: "
    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address

    # get a
    la $a0, gi_prompt_a
    jal get_input
    nop
    move $s0, $v0

    # get b
    la $a0, gi_prompt_b
    jal get_input
    nop
    move $s1, $v0

    # get carryin
    la $a0, gi_prompt_c
    jal get_input
    nop
    move $s2, $v0
    
    # LOGICAL OPERATIONS BEGIN HERE

    # Our three AND gates, these run in parallel
    and $t0, $s0, $s2       # a AND CarryIn
    and $t1, $s1, $s2       # b AND CarryIn
    and $t2, $s0, $s1       # a AND b

    # 3 way OR of the above (x OR y OR z = (x OR y) OR z)
    or $t0, $t0, $t1        
    or $t0, $t0, $t2       

    # $t0 is our CarryOut 
    la $a0, result          # print result msg
    li $v0, 4
    syscall

    move $a0, $t0           # print CarryOut
    li $v0, 1           
    syscall

    # LOGICAL OPERATIONS END HERE

    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop

# $a0 is prompt
get_input:
    li $v0, 4                   # print prompt
    syscall

    li $v0, 5                   # read_int
    syscall

    # validate 0 or 1
    andi $t0, $v0, 0x1       # get just the last bit
    bne $t0, $v0, gi_err     # if the rest of the bits were 0, we're ok - if information was lost, 0 or 1 was not inputted so error

    # OK input, so return $v0
    jr $ra

gi_err:
    la $a0, gi_err_msg
    li $v0, 4
    syscall

    # terminate
    li $v0, 10
    syscall