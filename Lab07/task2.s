# Mitchell Merry
# 2021, Computer Organisation, WSU
# Lab 07

    .data
    .align 2
prompt: .asciiz "\nEnter a value for p: "
rib_error: .asciiz "Your value does not fit the range. Exiting..."
out_un: .asciiz "Unsigned value: "
out_sn: .asciiz "\nSigned value: "
    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address

    li $s3, 1                   # p

m_loop:

    la $a0, prompt              # read value for p
    li $v0, 4                   # print_string
    syscall

    li $v0, 5                   # read_int
    syscall

    move $s3, $v0               # store p in $s3
    beq $s3, $0, Exit           # exit program if p = 0


    li $s0, 5                   # n, m
    li $s1, 3

    add $a0, $v0, $0            # pass p into extract as $a0
    add $a1, $0, $s0           # pass n (5) into extract
    add $a2, $0, $s1           # pass m (3) into extract
    jal extract
    nop

    move $s2, $v0

    li $v0, 4
    la $a0, out_un              # unsigned integer msg
    syscall

    add $a0, $0, $s2            # unsigned integer
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, out_sn              # signed integer msg
    syscall

    li $t1, 32                  # shamt = 32
    sub $t1, $t1, $s0           # shamt = 32 - n
    sllv $s2, $s2, $t1          # shift num 32-n bits to the left
    srav $s2, $s2, $t1          # shift right arithmetic all the way to the right, preserving signed bit

    add $a0, $0, $s2            # signed integer
    li $v0, 1
    syscall

    j m_loop

# Extracts an n-bit field starting at bit m from a 32-bit value p
# Precondition:     $a0 - p
#                   $a1 - n
#                   $a2 - m
# Postcondition:    $v0 - extracted bit field
extract:
    sub  $sp, $sp, 12    
    sw  $a2, 8($sp)    
    sw  $a1, 4($sp)  
    sw  $a0, 0($sp) 

    li $t0, 0xffffffff          # mask
    li $t1, 32                  # shamt = 32
    sub $t1, $t1, $a1           # shamt = 32 - n
    srlv $t0, $t0, $t1          # shift the mask 32-n bits to the right logically (only n bits remaining from position 0)
    srlv $t2, $a0, $a2          # shift p m bits to the right (so the least significant bit is at positiion 0)
    and $t3, $t0, $t2           # the bit group

    add $v0, $t3, $0

    lw  $a0, 0($sp)
    lw  $a1, 4($sp)  
    lw  $a2, 8($sp)    
    add  $sp, $sp, 12  
    jr  $ra  

# Ensures valid user input between [$a0, $a1]. Exits on fail.
# Note: previously this function was used to loop until correct
# input, hence the rib_loop label.
# Precondition:     $a0 - minimum value
#                   $a1 - maximum value
#                   $a2 - address for prompt
# Postcondition:    $v0 - value from the user
read_int_between:
    move $t0, $a0               # save minimum in $t0 (otherwise it gets overwritten)
    move $t1, $a1               # save maximum in $t1 (for conformity)

#rib_loop:
    li $v0, 4                   # syscall code for print_string
    add $a0, $0, $a2                 # print the prompt
    syscall

    li $v0, 5                   # syscall code for read_int
    syscall                     # take in the value of N to $v0

    sle $t2, $t0, $v0           # $t2 = $a0 <= N
    sle $t3, $v0, $t1           # $t3 = N <= $a1
    bne $t2, $t3, rib_exit      # exit if both are not true. They cannot both be simultaneously false
                                # so this guarantees that $a0 <= N <= $a1

    move $a0, $t0               # restore $a0
    move $a1, $t1               # restore $a1 (not necessary)
    jr $ra
    nop

rib_exit:
    li $v0, 4                   # syscall code for print_string
    la $a0, rib_error           # print the error message
    syscall

    j Exit
    nop

Exit:
    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop