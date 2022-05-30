# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 08

    .data
    .align 2

    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address
    
    # initialise t2 to 0.0
    li.d $f4, 0.0
    li.d $f8, 0.1               # increment value
    li.d $f10, 1.0              # max value

loop:
    # 5 / (5 - 4t2)
    li.d $f0, 4.0
    li.d $f2, 5.0

    mul.d $f0, $f0, $f4         # 4t2
    sub.d $f0, $f2, $f0         # 5 - 4t2
    div.d $f0, $f2, $f0         # 5 / (5 - 4t2)
    ##

    # print t2
    mov.d $f12, $f4             # load t2 to print
    li $v0, 3                   # syscall code for print_double
    syscall

    # print space character
    li $v0, 11
    li $a0, 32
    syscall
    
    # print speedup
    mov.d $f12, $f0             # load speedup to print
    li $v0, 3                   # syscall code for print_double
    syscall

    # print newline character
    li $v0, 11
    li $a0, 10
    syscall

    # increment t2 and loop if within range
    add.d $f4, $f4, $f8
    c.le.d $f4, $f10            # t2 <= 1.0
    bc1t loop

Exit:
    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop