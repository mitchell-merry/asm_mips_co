# search.s
# 
# This program performs linear search through an array
# of Alen words, starting at address Astart.
# At termination, address Index contains the index
# of the entry with value equal to the word at address Key;
# if no entry has that value, Index is Alen &lt;--- note!
# The basic algorithm is to examine each array entry in succession,
# starting at the low memory end of the array, and leaving the loop
# once a match is found.
# The loop is controlled by the index starting at 0.
  
    .data
Alen:    .word  10
Astart:  .word  1,-2,-3,-1,3,6,-7,2,0,-9
Key:     .space  4
Index:   .word  -1

    .text
    .globl main
main:
    .text
    addu  $s7, $0, $ra  #save the return address in a global register

          # initialize register contents
    li  $t0, 0              # $t0 is an index in the array A     
    li  $t1, 0              # $t1 is a byte displacement from Astart    
    lw  $t2, Alen           # $t2 is always the size of A (in words)
    li  $t3, 0              # $t3 is used to store the entry being examined    

    .data
    .globl  message1
message1:  .asciiz  "\nSearch for the element with the value: "  #string to print

    .text
    li  $v0, 4              # print_str (system call 4)
    la  $a0, message1       # takes the address of string as an argument
    syscall
    li    $v0, 5            # read_int (system call 5)
    syscall
    add   $t4, $0, $v0      # $t4 is always the value being searched for
    sw    $t4, Key          # key stored

loop:
    add   $t1, $t0, $t0
    add   $t1, $t1, $t1     # calculate byte displacement as 4 times index
    lw    $t3, Astart($t1)  # load element of array A
    beq   $t3, $t4, L1      # goto exit if current entry has right value
    addi  $t0, $t0, 1       # increment index
    bne   $t0, $t2, loop    # terminate loop once new index equals Alen
L1:
    sw   $t0, Index         # store answer in memory
    .data
    .globl  message2
message2:  .asciiz "\nThe index of the element is: "  #string to print
    .text
    li  $v0, 4              # print_str (system call 4)
    la  $a0, message2       # takes the address of string as an argument
    syscall
    li  $v0, 1              # print_int (system call 1)
    add  $a0, $0, $t0       # put value to print in $a0
    syscall
          # Usual stuff at the end of the main
    addu  $ra, $0, $s7      # restore the return address
    jr  $ra                 # return to the main program
    add  $0, $0, $0         # nop