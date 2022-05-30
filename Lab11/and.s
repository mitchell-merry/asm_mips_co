# start of the main program
# this program can be used as a starting point to simulate logic
# circuits used to build ALU. It only implements one logic function.
# Author: Derek Bem, 2008

  .text
  .globl main
main:                        # main has to be a global label
    addu $s7, $0, $ra        # save the return address in a global register

#------------------------------------ getting a
    .data
    .globl  message1
message1:  .asciiz "\n\nInput 0 or 1 for a: "  #string to print

    .text
    li   $v0, 4              # print_string (system call 4)
    la   $a0, message1       # takes the address of string as an argument 
  syscall
  
    li   $v0, 5              # read_int (system call 5) 
    syscall          

    # validate 0 or 1
    andi $t0, $v0, 0x1       # get just the last bit
    bne $t0, $v0, inval_input  # if the rest of the bits were 0, we're ok - if information was lost, 0 or 1 was not inputted so branch
    
    add  $s3, $0, $v0        # move to $s3
   #sw   $s3, p              # p is stored
  
#------------------------------------ getting b
    .data
    .globl  message2
message2:  .asciiz "Input 0 or 1 for b: "  #string to print

    .text
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message2       # takes the address of string as an argument 
    syscall
  
    li   $v0, 5              # read_int (system call 5)
    syscall        

    # validate 0 or 1
    andi $t0, $v0, 0x1       # get just the last bit
    bne $t0, $v0, inval_input  # if the rest of the bits were 0, we're ok - if information was lost, 0 or 1 was not inputted so branch
    

    add  $s4, $0, $v0        # move to $s4

#----------------------------------- calculating (a AND b)
    and  $t0, $s3, $s4       # register $t0 contains (a AND b)

#----------------------------------- printing a AND b on the console
    .data
    .globl message3  
message3:  .asciiz "           a AND b: "  # string to print
message4:  .asciiz "\n---------------------" # next string to print

    .text
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message3       # takes the address of string as an argument 
    syscall

    li   $v0, 1              # print_int (system call 1)
    add  $a0, $0, $t0        # put value to print in $a0
    syscall  

    li   $v0, 4              # print_str (system call 4)
    la   $a0, message4       # takes the address of string as an argument 
    syscall

    j  main                  # back to calculating  

inval_input:
    .data
    .globl err
    err: .asciiz "\n Incorrect input. Please input 0 or 1."
    .text

    li $v0, 4               # print error
    la $a0, err
    syscall

    j main                  # restart

#----------------------------------- usual stuff at the end of the main
    addu $ra, $0, $s7        # restore the return address
    jr   $ra                 # return to the main program
