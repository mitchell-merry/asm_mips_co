# this programs asks for temperature in Fahrenheit
# and converts it to Celsius

  .text    
         .globl main  
main:                 # main has to be a global label
  addu  $s7, $0, $ra  # save return address in a global register
  
  
      # GETTING INPUT VALUE
  
  la $a0,input        # print message "input" on the console
  li $v0,4
  syscall

  li $v0,5            # syscall code for read integer
  syscall             # gets int from user and stores in $v0
  
      # CALCULATING  
  # F is stored in $v0
  addi $t0,$v0,-32    # F-32
  mul  $t0,$t0,5      # 5(F-32)
  div  $t0,$t0,9      # 5/9 * (F-32)

      # PRINTING

  la $a0,result       # prepare 'result' for printing
  li $v0,4            # syscall code for print_string
  syscall             # print the string at result

  move $a0,$t0        # $a0 = C (prepare the actual result for printing)
  li $v0,1            # syscall code for print_int
  syscall             # print the celsius result to screen

  .data
input:  .asciiz "\n\nEnter temperature in Fahrenheit: "
result:  .asciiz "The temperature in Celsius is: "
  
  .text
  addu  $ra, $0, $s7 # restore the return address
  jr  $ra            # return to the main program
  add  $0, $0, $0    # nop (no operation)