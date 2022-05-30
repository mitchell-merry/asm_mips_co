# This program utilises memory mapped I/O to input single 
# characters from the keyboard, and to display them 
# in the console window.
# The character "\n" (enter) terminates the program.
# Author: Derek Bem

    .text
    .globl main
main:                          # main has to be a global label
     addu $s7, $0, $ra         # save the return address in a global register

    .data
    .globl msg1
msg1:   .asciiz "\nStart entering characters ('Enter' terminates the program): \n"   # string to print
    .align 2

terminator:  .ascii "\n"
    .text
    li  $v0, 4                 # print_str
    la  $a0, msg1              # takes address of string as argument
    syscall

    li  $t0, 0xffff            # first place 0000ffff in $t0
    sll $t0, $t0, 16           # so we now have ffff0000 in $t0

readloop:
    lw   $t1, 0($t0)           # receiver control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero,readloop   # if not ready
    lb   $s0, 4($t0)           # receiver data

    lbu  $s1, terminator       # load terminating character
    beq  $s0, $s1, exit        # terminate

             # Write to display from $s0
writeloop:
    lw  $t1, 8($t0)            # transmitter control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero,writeloop  # if not ready
    sw   $s0, 12($t0)          # transmit data
    j  readloop                # continue

    .globl msg2
    .data
    .align 2
msg2: .asciiz "\nProgram terminated\n"  # string to print

    .text
exit:
    li  $v0, 4                 # print_str
    la  $a0, msg2              # takes address of string as argument
    syscall

             # Usual stuff at the end of the main
    addu	$ra, $0, $s7       # restore the return address
    jr  $ra                    # return to the main program
    add $0, $0, $0             # nop