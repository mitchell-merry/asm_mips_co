# actual start of the main program
# implements the following examples from the textbook - Ed3 Chapter 2.3
#         g = h + A[8]
#         A[12] = h + A[8]
#         g = h + A[i]
# assumes:
#  variables g and h are in registers $s1 and $s2
#  base address of array A is in $s3
#  variable i is in $s4

#-------------------------------------Allocate an array A with a number of words
  .data
  .align  2             # Let's make sure that it's aligned  
A: .word  10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30   
                        # above we allocated and initialized
                        # twenty elements of array A
  .space  320           # here we allocated space here for...
                        # ...how many more elements?
  .text
  .globl main
main:          # main has to be a global label
  addu  $s7, $0, $ra    # save the return address
          # in a global register
  addi  $s2, $0, 40     # set h to 40 for the examples      
  addi  $s4, $0, 6      # set i to 6 for the examples
  la  $s3, A            # $s3 has the starting address of A
#-------------------------------------Compute g = h + A[8]
  .text
  lw  $t0, 32($s3)      # Temporary register $t0 gets A[8]
  add  $s1, $s2, $t0    # Calculate g = h + A[8]
   #----------------------------------Output the value of g
  .data
  .globl  message1  
message1:  .asciiz "\nThe value of g = h + A[8] is: " # string to print
  .text
  li  $v0, 4            # print_str (system call 4)
  la  $a0, message1     # takes the address of string as an argument
  syscall
  li  $v0, 1            # print_int (system call 1)
  add  $a0, $0, $s1     # put value g in $a0 for printing
  syscall
#-------------------------------------Compute A[12] = h + A[8]
  .text 
  lw  $t0, 32($s3)      # Temporary register $t0 gets A[8] 
  add  $t0, $s2, $t0    # Temporary register $t0 gets h + A[8]
  sw  $t0, 48($s3)      # Store h + A[8] back in A[12]
  
   #----------------------------------Output the value of A[12]
  .data 
  .globl  message2
message2:  .asciiz "\nThe value of A[12] is: "        # string to print
  .text
  li  $v0, 4            # print_str (system call 4)
  la  $a0, message2     # takes the address of string as an argument
  syscall
  li  $v0, 1            # print_int (system call 1)
  lw  $a0, 48($s3)      # load A[12] into $a0 for printing
  syscall
#------------------------------------Compute g = h + A[i]
  .text
  add  $t1, $s4, $s4    # Compute offset of A[i] from start in bytes
  add  $t1, $t1, $t1    # as 4*i
                        # Note: shifts not covered yet so add is used
  add  $t1, $t1, $s3    # Compute the actual address of A[i]: A + 4*i
  lw  $t0, 0($t1)       # Temporary register $t0 gets A[i]
  add  $s1, $s2, $t0    # Calculate g = h + A[i]
#---------------------------------Output the value of g
  .data
  .globl  message3
message3:  .asciiz "\nThe value of g = h + A[i] is: " # string to print
  .text
  li    $v0, 4          # print_str (system call 4)
  la    $a0, message3   # takes the address of string as an argument
  syscall
  li    $v0, 1          # print_int (system call 1)
  add    $a0, $0, $s1   # put value of g in $a0 for printing
  syscall            
#--------------------------------------Usual stuff at the end of the main
  addu  $ra, $0, $s7     # restore the return address
  jr    $ra              # return to the main program