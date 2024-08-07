.data
    num_msg:    .asciiz "Enter Integer\n"
    quo_msg:    .asciiz "Quotient:"
    rem_msg:    .asciiz "Remainder:"
    space:      .asciiz " "
    newline:    .asciiz "\n"
    end_msg:    .asciiz "\n    Done!!\n"

.text
.globl main

main:
    # Get input
    li $v0, 4
    la $a0, num_msg
    syscall
    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = input number

    # Initialize quotient
    li $t1, 0      # $t1 = quotient

    # Determine which loop to use
    bgez $t0, positive_loop
    j negative_loop

positive_loop:
    li $t3, 255
    blt $t0, $t3, print_result
    sub $t0, $t0, $t3
    addi $t1, $t1, 1
    j positive_loop

negative_loop:
    li $t3, 255
    bgez $t0, print_result
    add $t0, $t0, $t3
    addi $t1, $t1, -1
    j negative_loop

print_result:
    # Print quotient
    li $v0, 4
    la $a0, quo_msg
    syscall
    li $v0, 4
    la $a0, space
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Print remainder
    li $v0, 4
    la $a0, rem_msg
    syscall
    li $v0, 4
    la $a0, space
    syscall
    li $v0, 1
    move $a0, $t0
    syscall

    # Print end message
    li $v0, 4
    la $a0, end_msg
    syscall

    # Exit program
    li $v0, 10
    syscall