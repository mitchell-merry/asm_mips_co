# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 08

    .data
    .align 2
promptT: .asciiz "Enter a value for T: "
promptN: .asciiz "Enter a value for N between 0-20: "
promptt2: .asciiz "Enter a value for t2: "
errorN: .asciiz "Invalid value for N. Exiting..."

speedup: .asciiz "Calculated Speedup is: "
    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address

    # Read value for T
    la $a0, promptT             # print the T prompt
    li $v0, 4                   # syscall code for print_string
    syscall

    li $v0, 7                   # syscall code for read_double
    syscall
    mov.d $f8, $f0              # store input in $f8

    # Read value for N between 0 and 20
    li $a0, 0
    li $a1, 20
    la $a2, promptN
    la $a3, errorN
    jal read_fp_val
    nop
    l.d $f4, 0($v0)             # store value for N in $f4

    # Read value for t2
    la $a0, promptt2          # print the t2 prompt
    li $v0, 4                   # syscall code for print_string
    syscall

    li $v0, 7                   # syscall code for read_double
    syscall
    mov.d $f6, $f0              # store input in $f6

    # Calculations
    # Speedup = T / T'
    # T = t1 + t2
    # T' = t1 + t2'
    # T' = t1 + t2/N
    # T' = T - t2 + t2/N
    # Speedup = T / (T - t2 + t2/N)

    # $f4 - N
    # $f6 - t2
    # $f8 - T

    div.d $f0, $f6, $f4         # t2/N
    sub.d $f0, $f0, $f6         # -t2 + t2/N 
    add.d $f0, $f8, $f0         # T - t2 + t2/N
    div.d $f0, $f8, $f0         # T / (T - t2 + t2/N)

    # Print speedup msg
    la $a0, speedup
    li $v0, 4
    syscall

    # Print result
    li $v0, 3                   # syscall code for print_double
    mov.d $f12, $f0
    syscall

    j Exit

# Reads a double from the keyboard between two integer values, if out of range errors
# Precondition:     $a0 - minimum value (address to floating point value)
#                   $a1 - maximum value
#                   $a2 - prompt (address to string)
#                   $a3 - error message (address)
# Postcondition:    $v0 - address to floating-point value in memory
read_fp_val:
    # Save values to stack
    addi $sp, $sp, -4
    sw $a0, 0($sp)          # used to pass values to syscall
    
    mtc1.d $a0, $f2         # convert min and max to doubles
    cvt.d.w $f2, $f2
    mtc1.d $a1, $f4
    cvt.d.w $f4, $f4

    # Print the given prompt
    move $a0, $a2
    li $v0, 4               # syscall code for print_string
    syscall
    
    # Read value from user (into $f0-f1)
    li $v0, 7               # syscall code for read_double
    syscall

    c.lt.d $f0, $f2         # value < minimum?
    bc1t rfpv_error         # if so, error!
    c.lt.d $f4, $f0         # maximum < value?
    bc1f rfpv_exit          # if not, then all is in order and we can exit and return. if not, it'll error

rfpv_error:
    move $a0, $a3           # load error message
    li $v0, 4               # syscall code for print_string
    syscall

    li $v0, 10              # syscall code for exit
    syscall

rfpv_exit:
    li $v0, 9               # syscall code for sbrk
    li $a0, 8               # 8 bytes, double
    syscall

    s.d $f0, 0($v0)         # store double at dynamically allocated address (& return it in $v0)

    # Restore from the stack
    lw $a0, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra                   # return control to caller

Exit:
    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop