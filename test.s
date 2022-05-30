#     .data
# str1: .asciiz "this string has n characters"
#     .align 2
# abc: .word 2, 4, 7, 9
    
#     .text
#     .globl main
# main:
#     addu $s7, $0, $ra # save the return address.

#     li $s0, -1

#     srl $v0, $s0, 1

#     addiu $a0, $v0, 1

#     addu $ra, $0, $s7       # restore return address
#     jr $ra                  # return to the return address
#     add $0, $0, $0          # nop

    .data
    .align 0
aaa: .ascii "n"
bbb: .word 0x7F3, 0x7F2, 0x7F1
    .text
    .globl main
main:
    li $v0, 1
    lw $a0, bbb
    syscall
    add $0, $0, $0
#     li $t0, 0xffff
#     sll $t0, $t0, 16
#     la $s3, msg
#     lw $s1, 0($s3)
#     srl $s2, $s1, 16
#     srl $s2, $s1, 16
# lp:
#     lb $t1, 8($t0)
#     andi $t1, $t1, 0x0001
#     beq $t1, $zero, lp
#     sb $s1, 12($t0)