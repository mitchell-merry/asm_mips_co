    .data
str1: .asciiz "this string has n characters"
    .align 2
abc: .word 2, 4, 7, 9
    
    .text
    .globl main
main:
    addu $s7, $0, $ra # save the return address.

    

    addu $ra, $0, $s7       # restore return address
    jr $ra                  # return to the return address
    add $0, $0, $0          # nop