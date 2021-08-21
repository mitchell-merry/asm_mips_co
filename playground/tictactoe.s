# Program that plays a game of tic-tac-toe, entirely in MIPS assembly.
# Register descriptions:
# $s0 - current board turn
    .data
    .align 2
board: # 2d 3x3 array containing -1, 0, or 1
    .space 36                
    # .word 1, -1, 0, -1, 1, -1, 1, -1, 1

# Board print strings
row_sep: .asciiz "---+---+---\n"
X: .asciiz "X"
O: .asciiz "O"

# Console messages
init_message: .asciiz "Game initialised.\n"
row_prompt: .asciiz "Row (0-2): "
column_prompt: .asciiz "Column (0-2): "
header_msg_1: .asciiz "\n==Player "
header_msg_2: .asciiz "'s turn==\n"
set_cell_occupied: .asciiz "Cell already occupied.\n"
    .text
    .globl main
main:
    # Push values onto the stack
    addi $sp, $sp, -24          # main
    sw $s3, 20($sp)             # used to store current turn
    sw $s2, 20($sp)             # used to store column user input
    sw $s1, 16($sp)             # used to store row user input
    sw $s0, 12($sp)             # game_loop counter (turn)
    sw $a1, 8($sp)              # used for argument passing
    sw $a0, 4($sp)              # used for syscalls
    sw $ra, 0($sp)

    # Initialise the game
    jal init
    nop

    # Main loop of the game. Loops over turns until max turn is reached (0-8).
    # Even turns represent player X (1), odd turns represent player O (-1)
game_loop:
    # Get turn (1 or -1)
    move $a0, $s0               # pass current turn of the board        
    jal get_turn                # into get_turn
    nop
    move $s3, $v0

    # Print the header.
    move $a0, $s3               # pass in the current player
    jal print_header            # print message
    nop

    # Print the board to show the current state of the board on each turn.
    jal print_board
    nop

    # Get values for row and column from user:
gl_get_inputs:
    # Pass arguments to read_int_between
    li $a0, 0                   # minimum value to read is 0
    li $a1, 2                   # maximum value to read is 2

    la $a2, row_prompt          # Get row from user
    jal read_int_between        
    nop 
    move $s1, $v0               # store row in $s1
    
    la $a2, column_prompt       # Get column from user
    jal read_int_between        
    nop
    move $s2, $v0               # store column in $s2

    # Set the cell value at (row, column) to the current player
    move $a0, $s1               # pass row
    move $a1, $s2               # pass column
    move $a2, $s3               # pass turn
    jal set_cell
    nop

    bne $v0, $0, gl_get_inputs  # if the cell was occupied (returned a non-zero error code), get inputs again

    li $t0, 9                   # board turn limit
    addi $s0, $s0, 1            # increment board turn counter
    bne $s0, $t0, game_loop     # loop if board turn limit not reached
    
    jal print_board
    nop


    j exit_program

# init: Initalises program registers and values to an empty game of
#       tic-tac-toe at turn 0.
# Precondition: None
# Postcondition:
#   Board Turn - $s0 - set to 0.
init:
    li $s0, 0                   # Initialise board-turn to 0

    # Print completed initialisation message
    li $v0, 4                   # syscall code for print_str
    la $a0, init_message        # pass init message
    syscall

    jr $ra

# get_turn: Returns the current player to move. If the board turn is even,
#           return 1 (player 1), if it's odd, return -1 (player 2)
# Precondition:     $a0 - board turn (0-8)
# Postcondition:    $v0 - current turn (1 or -1)
get_turn:
    # Determine if odd or even
    li $t0, 2                   # get_turn
    div $a0, $t0                # divide turn by 2
    mfhi $t0                    # get remainder

    # If remainder is 0, return 1, else return -1
    li $v0, 1                   # return 1
    beq $t0, $0, __gt_ret       # if remainder == 0 return
    li $v0, -1                  # return -1

__gt_ret:
    jr $ra

# get_cell: Returns the value stored in the given row / column in the board.
# Precondition:     $a0 - row
#                   $a1 - column
# Postcondition:    $v0 - value at board[row][column] (-1, 0, or 1)
get_cell:
    la $t1, board               # Load the base address of board
    
    # board[row][column] is stored at:
    # board + row*3*4 + column*4
    li $t2, 0
    add $t2, $a0, $a0           # 2*row
    add $t2, $t2, $a0           # 3*row
    add $t2, $t2, $t2           # 3*2*row
    add $t2, $t2, $t2           # 3*4*row

    add $t3, $a1, $a1           # 2*column
    add $t3, $t3, $t3           # 4*column

    add $t2, $t2, $t3           # 3*4*row + 4*column
    add $t1, $t1, $t2           # board + 3*4*row + 4*column
                                # the address of the element in the board.
    
    lw $v0, 0($t1)              # Load the value at the calculated address into
                                # the return argument

    jr $ra

# set_cell: Sets the value of the cell at row,column to value.
# Precondition:     $a0 - row
#                   $a1 - column
#                   $a2 - value
# Postcondition:    $v0 - error code 1 if cell is occupied, 0 if success
set_cell:
    # Push values onto the stack
    addi $sp, $sp, -4           # set_cell
    sw $a0, 0($sp)              # syscalls

    la $t1, board               # Load the base address of board
    
    # board[row][column] is stored at:
    # board + row*3*4 + column*4
    li $t2, 0
    add $t2, $a0, $a0           # 2*row
    add $t2, $t2, $a0           # 3*row
    add $t2, $t2, $t2           # 3*2*row
    add $t2, $t2, $t2           # 3*4*row

    add $t3, $a1, $a1           # 2*column
    add $t3, $t3, $t3           # 4*column

    add $t2, $t2, $t3           # 3*4*row + 4*column
    add $t1, $t1, $t2           # board + 3*4*row + 4*column
                                # the address of the element in the board.
    
    # Check if cell occupied
    lw $t0, 0($t1)              # get value in cell
    bne $t0, $0, __sc_err       # if the cell is not empty (i.e. occupied), throw error

    # Otherwise, set as normal
    li $v0, 0                   # no error
    sw $a2, 0($t1)              # Store the value in the calculated address
    j __sc_exit                 # return

    # If the cell is occupied
__sc_err:
    li $v0, 4                   # syscall code for print_str
    la $a0, set_cell_occupied   # print error message that the cell is occupied
    syscall

    li $v0, 1                   # return error code 1

__sc_exit:
    # Push values onto the stack
    lw $a0, 0($sp)              
    addi $sp, $sp, 4           

    jr $ra

# print_board: Prints an ASCII representation of the current board state to the console.
# 1 is X, -1 is O, and 0 is a blank space
# Precondition / Postcondition: None
# Example for board state "00000001 ffffffff 00000000 ffffffff 00000001 ffffffff 00000001 ffffffff 00000001":
#  X | O |  
# ---+---+---
#  O | X | O  
# ---+---+---
#  X | O | X 
print_board:
    # Push values onto the stack
    addi $sp, $sp, -12          # print_board
    sw $s0, 8($sp)              # __pb_loop counter (row)
    sw $a0, 4($sp)              # used for syscalls
    sw $ra, 0($sp)

    # Loops over each row.
    li $s0, 0                   # instantiate counter to 0 (corresponds to current row)
__pb_loop:
    # Print row
    move $a0, $s0               # pass row to print_row
    jal print_row
    nop

    # Print row separator only if this isn't the last iteration
    li $t0, 2                   # max iteration
    beq $s0, $t0, __pb_l_end    # if counter == 2, exit loop
    
    # otherwise, print row separator and loop
    li $v0, 4                   # syscall code for print_str
    la $a0, row_sep             # pass the row separator string
    syscall

    addi $s0, $s0, 1            # increment loop counter by 1
    j __pb_loop                 # loop

    ## End loop
__pb_l_end:

    # Pop values off the stack
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $s0, 8($sp)                 
    addi $sp, $sp, 12

    jr $ra

# print_row: Prints an ASCII representation of the corresponding row state to the console.
# 1 is X, -1 is O, and 0 is a blank space
# Precondition:         $a0 - row
# Postcondition: None
# Example for board state "00000001 ffffffff 00000000 ffffffff 00000001 ffffffff 00000001 ffffffff 00000001"
# and printing row 0:
# " X | O |   "
print_row:
    # Push to the stack:
    addi $sp, $sp, -20          # print_row
    sw $s1, 16($sp)             # carries the row
    sw $s0, 12($sp)             # __pr_loop counter
    sw $a1, 8($sp)              # used to pass column to print_cell
    sw $a0, 4($sp)              # used for syscalls, and to pass row to print_cell
    sw $ra, 0($sp)              
    
    move $s1, $a0               # store row in $s1 for later use ($a0 gets overwritten)

    # Loops over each column (corresponding to cell)
    li $s0, 0                   # instantiate loop counter
__pr_loop:
    # Print the cell character
    move $a0, $s1               # pass row to get_cell
    move $a1, $s0               # pass column to get_cell
    jal get_cell                # get the value
    nop

    move $a0, $v0               # pass the value into print_cell
    jal print_cell              # print
    nop

    # Print character
    # for 0,1 print |, for 2 print \n
    li $a0, 0xa                 # pass the linefeed character ('\n', 0xa)
    li $t0, 2                   
    beq $s0, $t0, __pr_pc       # if counter == 2, print \n

    li $a0, 0x7c                # otherwise, print the bar character ('|', 0x7c)

__pr_pc:                        # print character
    li $v0, 11                  # syscall code for print_char
    syscall

    addi $s0, $s0, 1            # increment loop counter by 1
    li $t0, 3                   # max loop is 3
    bne $s0, $t0, __pr_loop     # loop if not at max

    ## End loop

    # Pop off the stack and restore values
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $s0, 12($sp)   
    lw $s1, 16($sp)   
    addi $sp, $sp, 20

    jr $ra

# print_cell: Prints an ASCII representation of a cell value to the console.
# 1 is X, -1 is O, and 0 is a blank space
# Precondition:         $a0 - value of cell
# Postcondition: None
print_cell:
    # Push onto the stack
    addi $sp, $sp, -12          # print_cell
    sw $s0, 8($sp)              # used to store the value of the cell ($a0)
    sw $a0, 4($sp)              # used for syscalls
    sw $ra, 0($sp)
    
    move $s0, $a0               # store value for later

    # print a space character
    li $v0, 11                  # syscall code for print_char
    li $a0, 0x20                # hex code for space (0x20)
    syscall

    # Print the tile
    move $a0, $s0               # pass in the value of the cell
    jal print_char
    nop

    # print another space
    li $v0, 11                  # syscall code for print_char
    li $a0, 0x20                # hex code for space (0x20)
    syscall

    # Pop off the stack
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $s0, 8($sp)
    addi $sp, $sp, 12

    jr $ra

# print_header: Prints "==Player X's turn==\n"
# Precondition:     $a0 - current turn (1 or -1)
# Postcondition:    None
print_header:
    # Push onto the stack
    addi $sp, $sp, -12          # print_header
    sw $s0, 8($sp)              # stores the turn
    sw $a0, 4($sp)              # used for syscalls
    sw $ra, 0($sp)              

    move $s0, $a0               # store the turn

    li $v0, 4                   # syscall code for print_str
    la $a0, header_msg_1        # first half of the header message
    syscall

    # Print the player
    move $a0, $s0               # pass in the turn
    jal print_char
    nop

    li $v0, 4                   # syscall code for print_str
    la $a0, header_msg_2        # second half of the header message
    syscall

    # Pop values off the stack and restore
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $s0, 8($sp)
    addi $sp, $sp, 12
    
    jr $ra

# print_char: Prints X, O, or a space depending on input
# Precondition:     $a0 - current turn (1, 0, or -1)
# Postconditrion:   None
print_char:
    # Push onto the stack
    addi $sp, $sp, -8           # print_char
    sw $s0, 4($sp)              # used to store the value of the cell ($a0)
    sw $a0, 0($sp)              # used for syscalls

    li $v0, 4                   # syscall code for print_str

    li $t0, 1
    la $a0, X                   # if the value is 1, print X
    beq $s0, $t0, __pc_print    # true -> print

    li $t0, -1
    la $a0, O                   # if the value is -1, print O
    beq $s0, $t0, __pc_print

    li $v0, 11                  # syscall code for print_char
    la $a0, 0x20                # otherwise print out a space character (0x20)
__pc_print:
    syscall

    # Pop off the stack
    lw $a0, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8

    jr $ra

# read_int_between: Gets int input from the user between a range [$a0, $a1].
#                   Prompts until a valid value is entered.
# Precondition:     $a0 - minimum value
#                   $a1 - maximum value
#                   $a2 - prompt string (address)
# Postcondition:    $v0 - value from the user
read_int_between:
    # Push onto the stack
    addi $sp, $sp, -8           # read_int_between
    sw $s0, 4($sp)              # used to store minimum val
    sw $a0, 0($sp)              # used for syscalls

    move $s0, $a0

rib_loop:
    li $v0, 4                   # syscall code for print_string
    move $a0, $a2               # print the prompt
    syscall

    li $v0, 5                   # syscall code for read_int
    syscall                     # take in the value of N to $v0

    sle $t2, $s0, $v0           # minimum <= N
    sle $t3, $v0, $a1           # N <= maximum
    bne $t2, $t3, rib_loop      # loop if both are not true. They cannot both be simultaneously false
                                # so this guarantees that 1 <= N <= 9

    # Pop values off the stack and restore
    lw $a0, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 4
    
    jr $ra

# Exits the program - usual stuff
exit_program:
    # Pop values off the stack and restore
    lw $ra, 0($sp)
    lw $a0, 4($sp)              
    lw $a1, 8($sp)              
    lw $s0, 12($sp)             
    lw $s1, 16($sp)            
    lw $s2, 20($sp)             
    addi $sp, $sp, -24          

    jr $ra
    nop