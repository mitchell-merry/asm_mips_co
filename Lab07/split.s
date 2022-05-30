# this program splits a 32-bit word into halves
# ie. two 16-bit signed integer values
# word to split is in register $a0, the halves are returned 
# in registers $v0, and $v1
# Author:  Derek Bem

    .text
    .globl main
main:                   #main has to be a global label
    addu  $s7, $0, $ra  #save the return address in a global register

loop:
  # Read in the word to split
    .data
    .globl  message1
message1:  .asciiz   "\nEnter an integer value: " #string to print
    .text
    li  $v0, 4          # print_str
    la  $a0, message1   # takes the address of string as an argument
    syscall

    li  $v0, 5          # read_int
    syscall
    beqz  $v0, exit1    # terminate on 0 value

    add  $a0, $v0, $0   # move $v0 to $a0
    jal  halves         # call the function halves
    add  $s0, $v0, $0   # save first return value
    add  $s1, $v1, $0   # save second return value
  
  # Now print out halves
    .data
    .globl  message2
message2:  .asciiz   "\nThe halves are: " #string to print
    .text
    li  $v0, 4         # print_str
    la  $a0, message2   # takes the address of string as an argument
    syscall
  
    li  $v0, 1          # print_intt
    add  $a0, $0, $s0   # put value to print in $a0
    syscall

    .data
    .globl  message3
message3:  .asciiz " and "    # string to print
    .text
    li  $v0, 4    # print_str
    la  $a0, message3   # takes the address of string as an argument
    syscall

    li  $v0, 1          # print_int
    add  $a0, $0, $s1   # put value to print in $a0
    syscall
    j  loop             # get another word

exit1:
    .data
    .globl  message4
message4:  .asciiz   "\nProgram terminated. " #string to print
    .text
    li  $v0, 4          # print_str
    la  $a0, message4   # takes the address of string as an argument
    syscall

          # Usual stuff at the end of the main
    addu  $ra, $0, $s7  # restore the return address
    jr  $ra             # return to the main program
    add  $0, $0, $0     # nop

  # subroutine halves

    .globl  halves
halves:
    sub  $sp, $sp, 8    # make space on the stack for two items
    sw  $s1, 4($sp)     # save register $s1       
    sw  $s0, 0($sp)     # save register $s0

    add  $s0, $a0, $0   # register $s0 contains the word to split
    sra  $v0, $s0, 16   # extract the upper half
    add  $s1, $0, 0xffff      # create a mask
    and  $s1, $s1, $s0  # extract the lower half
    sll  $s1, $s1, 16   # ensure sign extention
    sra  $v1, $s1, 16   # return to position
    
    lw  $s0, 0($sp)     # restore register $s0
    lw  $s1, 4($sp)     # restore register $s1
    add  $sp, $sp, 8    # adjust the stack before the return 
    jr  $ra             # return to the calling program