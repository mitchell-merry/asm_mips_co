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

  li $v0,5
  syscall
  
      # CALCULATING  
  
  addi $t0,$v0,-32    # __??
  mul  $t0,$t0,5      # __??
  div  $t0,$t0,9      # __??

      # PRINTING

  la $a0,result       # __?
  li $v0,4            # __?
  syscall             # __?

  move $a0,$t0        # __?
  li $v0,1            # __?
  syscall             # __?

  .data
input:  .asciiz "\n\nEnter temperature in Fahrenheit: "
result:  .asciiz "The temperature in Celsius is: "
  
  .text
  addu  $ra, $0, $s7 # restore the return address
  jr  $ra            # return to the main program
  add  $0, $0, $0    # nop (no operation)