# note roles of sections separated by directives '.data' and '.text'
# read from the textbook: 'Memory Usage', whole chapter  A.5 (PH3) [or B.5 (PH4), and
# relevant sections of chapter A-10 (PH3) [or B-10 (PH4) under 'Assembler Syntax' 

  .text              # start of instructions
                     # (stored in user text segment)
  .globl main        # main has to be a global label
main:    
					 # 
	li $v0, 4        # instructions 'li' and 'la' define
                     # arguments for system call instructions.
                     # li loads digit 4 into register $v0
    la $a0, label1   # la loads computed address of label1
                     # into register $a0
   syscall           # to see what syscall does:
                     # see the textbook Appendix A.9 (PH3) or B.9 (PH4)
                     # In short: syscall 4 prints data taken 
                     # from memory address found in register $a0
   .data             # start of data (stored in data segment)
label1:  .asciiz "Hello there"         # p. A-48 (PH3) or B-48 (PH4) explains directive .asciiz

# Single step in PCSpim and observe changes in all registers, and in memory
# location where ASCII characters corresponding to "Hello there" are stored.
# When you fully understand what this program does, try 'helloimproved.s
