    .data
    .align 2

    .text
    .globl main
main:
    addu $s7, $0, $ra           # save the return address



    # Usual stuff at the end of main.
    addu $ra, $0, $s7           # restore the return address
    jr $ra
    nop