#  start of the main program to perform the calculation
#  f = (g + h) - (p + q)  (see PH Ed3 Chapter 2.3)
#  assumes: variables f through h are in memory,
#  but variables p and q are read in from the keyboard
#  and stored in memory locations

  .data
f:  .word  0            # simple/single variable
g:  .word  5
h:  .word  -15
p:  .word  0            # does it matter that it is 0?
q:  .word  0            # does it matter that it is 0?

  .text
  .globl main
main:                   # main has to be a global label
  addu  $s7, $0, $ra    # save the return address in a global register
  lw  $s1, g            # g = 5
  lw  $s2, h            # h = -15
#------------------------------------getting p
  .data
  .globl  message1  
message1:  .asciiz "\nInput value for p: "  #string to print

  .text
  li  $v0, 4            # print_string (system call 4)
  la  $a0, message1     # takes the address of string as an argument 
  syscall
  li  $v0, 5            # read_int (system call 5) 
  syscall
  add  $s3, $0, $v0     # move to $s3
  sw  $s3, p            # p is stored
#------------------------------------getting q
  .data
  .globl  message2
message2:  .asciiz "\nInput value for q: "    #string to print

  .text
  li  $v0, 4            # print_str (system call 4)
  la  $a0, message2     # takes the address of string as an argument 
  syscall
  li  $v0, 5            # read_int (system call 5)
  syscall
  add  $s4, $0, $v0     # move to $s0
  sw  $s4, q            # q is stored
#-----------------------------------calculating f
  add  $t0, $s1, $s2    # register $t0 contains g + h
  add  $t1, $s3, $s4    # register $t1 contains p + q
  sub  $s0, $t0, $t1    # f = (g + h) - (p + q)
  sw  $s0, f            # store f
#-----------------------------------printing f on the console
  .data
  .globl  message3
message3:  .asciiz "\nThe value of f is: "  #string to print

  .text
  li  $v0, 4            # print_str (system call 4)
  la  $a0, message3     # takes the address of string as an argument 
  syscall

  li  $v0, 1            # print_int (system call 1)
  add  $a0, $0, $s0     # put value to print in $a0
  syscall

#------------------------------------usual stuff at the end of the main
  addu  $ra, $0, $s7    # restore the return address
  jr    $ra             # return to the main program