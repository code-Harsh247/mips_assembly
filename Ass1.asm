.data
    prompt:     .asciiz "Enter a number: "
    space:      .asciiz " "

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Read integer
    li $v0, 5
    syscall
    move $s0, $v0  # Store input in $s0

    # Call prime_factors function
    move $a0, $s0
    jal prime_factors

    # Exit program
    li $v0, 10
    syscall

prime_factors:
    # $a0: number to factorize
    # Uses $t0 as divisor
    # Uses $t1 for quotient
    # Uses $t2 for remainder

    li $t0, 2  # Start with smallest prime number

    factor_loop:
        blt $a0, 2, exit_function  # If number < 2, exit

        div $a0, $t0
        mflo $t1  # Quotient
        mfhi $t2  # Remainder

        beqz $t2, print_factor  # If remainder == 0, print factor

        # Try next divisor
        j try_next_divisor

    print_factor:
        # Print factor
        move $a0, $t0
        li $v0, 1
        syscall

        # Print space (for readability)
        li $v0, 4
        la $a0, space
        syscall

        # Update number to quotient
        move $a0, $t1
        j factor_loop

    try_next_divisor:
        # Increment divisor
        addi $t0, $t0, 1

        # Edge case for very small numbers
        blt $t0, $a0, factor_loop  # Continue if $t0 < $a0
        # Special case: If the remaining number is a prime number larger than the last divisor
        beq $a0, $t0, print_factor

        # Exit if all factors have been tried
        j exit_function

exit_function:
    jr $ra  # Return to caller
