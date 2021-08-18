# modified version of copy_carray.s
# reverses string stored in 'x' and prints it (copies to y, not in place).
    .data
x: .asciiz "copy m"                # string to reverse
y: .asciiz "      "                # string to reverse to

    .text
    .globl main
main:
    addu $s7, $0, $ra               # save the return address.

    # Initialise values
    la $a0, x
    la $a1, y                       # base address of arrays in memory
    li $s0, 0                       # counter

    li $s1, 0                       # size of string
    
get_size:
    add $t0, $a0, $s1               # address of x[i] in memory, the byte, not the word
    lb $t1, 0($t0)                  # load next byte/character into $t1
    
    beq $t1, $0, gs_exit            # if character is a NUL byte, exit loop 
    
    addi $s1, $s1, 1                # increment counter i
    j get_size                      # loop

gs_exit:
    addi $s1, $s1, -1               # conversion from size to max index (for ease of use later)

loop:
    add $t0, $a0, $s0               # address of x[i] in memory, the byte, not the word
    lb $t1, 0($t0)                  # load next byte/character into $t1
    
    beq $t1, $0, exit               # if character is a NUL byte, exit loop 
    
    sub $t2, $s1, $s0               # size-i-1
    add $t2, $a1, $t2               # address of y[size-i-1] in memory
    sb $t1, 0($t2)                  # copy x[i] into y[size-i-1], i.e., y[size-i-1] = x[i]

    addi $s0, $s0, 1                # increment counter i
    j loop                          # loop

exit:

    li $v0, 4
    move $a0, $a1
    syscall

    addu $ra, $0, $s7
    jr $ra
    nop