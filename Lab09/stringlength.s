# This file contains the main program that calls
# a procedure strlen, which should determine the length
# of a string. 
# The starting address of the string is passed as a parameter,
# and the length of the string is returned as a return parameter.
# Author: Derek Bem

      .data
Astr: .asciiz	"this is our test string, it is 49 characters long"
len:  .word	0

      .text
      .globl main
main:
      addu $s7, $0, $ra      # save return address in a global reg
      la $a0, Astr           # pass address of the string
      jal strlen             # calculate length
      sw $v0, len            # store length

      .data
      .globl message
message: .asciiz "\nThe length of the test string in the program is: "

      .text
      li $v0, 4              # print_string (system call 4)
      la $a0, message        # pass address
      syscall
      li $v0, 1              # print_int (system call 1)
      lw $a0, len            # put value to print in $a0
      syscall                #

# Usual stuff at the end of the main
      addu $ra, $0, $s7      # restore the return address
      jr  $ra                # return to the main program
      add $0, $0, $0         # nop

# Procedure strlen accepts the address of a string, and returns the
# length of that string.

      .text
      .globl	strlen
strlen:
         # This procedure calculates the length of a string
         # presented as a null-terminated sequence of bytes
         # start of the string in $a0
         # result returned in $v0
         # all registers except $v0 and $a0 must be preserved
         # The algorithm is a loop which examines each byte
         # starting at the beginning of the string.
         # save register contents
      addi $sp, $sp, -12     # make room on stack
      sw $s0, 0($sp)         # save $s0
      sw $s1, 4($sp)         # save $s1
      sw $s2, 8($sp)         # save $s2
         # $s0 stores the current character
         # $s1 stores the length so far
         # $s2 stores address of current character
      li $s1, 0              # initialize
loop:
      add $s2, $a0, $s1      # compute address
      lbu $s0, 0($s2)        # fetch character
      beqz $s0, done         # null byte is terminator
      addi $s1, $s1, 1       # increment length
      j loop                 # continue
done:
      move $v0, $s1          # put length in return register
              #restore registers
      lw $s0, 0($sp)         # restore $s0
      lw $s1, 4($sp)         # restore $s1
      lw $s2, 8($sp)         # restore $s2
      addi $sp, $sp, 12      # restore stack
      jr $ra                 # return