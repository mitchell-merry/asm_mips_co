# Mitchell Merry 
# 19726120
# 2021, Computer Organisation, 2021
# Example code used for 1.2.
    .data
    .align 2
abc: .word 2, 4, 7, 9
    
    .text
    .globl main
main:
    addu $s7, $0, $ra # save the return address.

    li $a0, 3                       # simply load an argument into $a0
    jal countdown                   # (passing 3 into our countdown function)
    nop

    j Exit                          # exit program

# prints a countdown and then count up
# $a0 - number to start with
countdown:
    li $v0, 1                       # load syscall code print_int
cd_main:
    addi $sp, -4                    # push return address to the stack
    sw $ra, 0($sp)

    syscall                         # print argument
    
    beq $a0, 0, countdown_exit      # if we hit 0, stop recursing

    addi $a0, -1                    # subtract 1 and recurse (count-down)
    jal cd_main                     
    nop

    addi $a0, 1                     # increase by 1 (count-up)
    syscall                         # print
    
countdown_exit:
    lw $ra, 0($sp)                  # pop the return address from the stack
    addi $sp, 4

    jr $ra                          # jump to the return address

# pseudocode:
# void countdown(int num) {
#     print(num);
#     if(countdown != 0) countdown(num-1);
#     print (num);
# }
# undefined for num < 0
Exit:
    addu $ra, $0, $s7       # restore return address
    jr $ra                  # return to the return address
    add $0, $0, $0          # nop
