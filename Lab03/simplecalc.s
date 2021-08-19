# The main program is to perform calculation as per formula: __??
# Note: A formula is a mathematical expression with variables. For this exercise, you need to declare some variables based on the calculation task.
# Variable and expression are standard and common terms in programming context. It's assumed you have understood them from learning Programming Fundamentals.
# places variables __?? ... __?? in registers __?? ... __??
#                        |                           |
#             list of variables          list of registers
# Mitchell Merry
# 19726120
#
  .data
  .globl  message  
message:  .asciiz "The value of f is: "   # allocate space in memory for message
extra:    .asciiz "\nHave a nice day :)"  # same for extra, but with a line feed character at the beginning
thankyou: .asciiz "\n\n\n ... Thank you :)"
  .align 2                  # align directive will be explained later

  .text
  .globl main
main:                       # main has to be a global label
  addu  $s7, $0, $ra        # save return address in a global register

        # CALCULATING

  addi  $s1, $0, 12         # g=12
  addi  $s2, $0, -2         # h=-2
  addi  $s3, $0, 13         # i=13
  addi  $s4, $0, 3          # j=3
  addi  $s5, $0, 5          # k=5
  add   $t0, $s1, $s2       # (g+h)
  sub   $t1, $s3, $s4       # (i-j)
  add   $t1, $t1, $s5       # (i-j+k)
  sub   $s0, $t0, $t1       # (g+h)-(i-j+k)

        # PRINTING
        
        # print the message "The value of f is: "
  li    $v0, 4             # ERROR
  la    $a0, message       # load the address of message into register $a0 for the syscall
  syscall                  # print the string at the message address until a null byte is encountered
  
        # print the value of f
  li    $v0, 1              # syscall code for print_int
  add   $a0, $0, $s0        # pass the result into syscall for printing
  syscall
  
        # print the extra message
  li    $v0, 4              # syscall code for print_string
  la    $a0, extra          # pass extra into syscall for printing
  syscall

  li    $v0, 4              
  la    $a0, thankyou          
  syscall
  
        # Usual stuff at the end of the main

  addu  $ra, $0, $s7        # restore the return address
  jr    $ra                 # return to the main program
  add   $0, $0, $0          # nop (no operation)