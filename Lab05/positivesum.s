# positivesum.s
# 
# This program adds the positive entries among the values in an array
# of Alen words, starting at address Astart.
# At termination, address Psum contains the sum of positive elements.
# The basic algorithm is to examine each array entry in succession,
# starting at the high memory end of the array.
# The loop is controlled by the byte displacement.
#
# $t0 - byte displacement from Astart
# $t1 - the entry being examined
# $t2 - accumulates the sum of positive entries examined
#
# initialize register contents
# initially $t0 is displacement of last entry
# namely 4 times the number of entries, minus 4
  
    .data
Alen:    .word  10
Astart:  .word  4, -2, 5, -1, 0, 6, -7, 1, 0, -10
Psum:    .word  0

    .text
    .globl main
main:
    addu  $s7, $0, $ra      # save the return address in a global register

    lw  $t0, Alen           # load length    
    add  $t0, $t0, $t0      # double
    add  $t0, $t0, $t0      # quadruple
    addi  $t0, $t0, -4      # back off one word  
    li  $t1, 0              # clear $t1    
    li  $t2, 0              # clear $t2
loop:
    bltz  $t0, L2           # terminate loop once displacement is negative
    lw  $t1, Astart($t0)    # load current entry
    blez  $t1, L1           # skip over addition if entry is not positive
    add  $t2, $t2, $t1      # add current entry to accumulation
L1: 
    addi  $t0, $t0, -4      # reduce displacement to consider another entry
    j  loop                 # continue
L2: 
    sw  $t2, Psum           # store total in word at address Psum

    .data
    .globl  message
message:  .asciiz "\nThe sum of positive elements is: "  #string to print
    .text
    li  $v0, 4              # print_str (system call 4)
    la  $a0, message        # takes the address of string as an argument
    syscall
    li  $v0, 1              # print_int (system call 1)
    add  $a0, $0, $t2       # put value to print in $a0
    syscall
            # usual stuff at the end of the main
    addu  $ra, $0, $s7      # restore the return address
    jr  $ra                 # return to the main program
    add  $0, $0, $0         # nop