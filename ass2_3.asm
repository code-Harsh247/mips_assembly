.data
    array:          .space 60     # Space for up to 15 integers (60 bytes)
    num_msg:        .asciiz "Enter number of elements in the array (15 at most):\n"
    enter_array:    .asciiz "Enter elements:\n"
    print_msg:      .asciiz "Longest increasing subarray is:\n"
    space:          .asciiz " "
    error_msg:      .asciiz "Error: Number of elements must be between 1 and 15.\n"

.text
.globl main

main:
    # Get number of elements
    li $v0, 4
    la $a0, num_msg
    syscall
    li $v0, 5
    syscall
    move $s0, $v0          # $s0 = number of elements

    # Check if number of elements is valid (1 <= n <= 15)
    li $t0, 1
    blt $s0, $t0, input_error
    li $t0, 15
    bgt $s0, $t0, input_error

    # Prepare for input loop
    la $s1, array          # $s1 = array address
    li $t0, 1              # $t0 = loop counter
    li $v0, 4
    la $a0, enter_array
    syscall

input_loop:
    bgt $t0, $s0, find_lis
    li $v0, 5
    syscall
    sw $v0, 0($s1)
    addi $s1, $s1, 4
    addi $t0, $t0, 1
    j input_loop

find_lis:
    la $s1, array
    li $t0, 2              # loop counter
    li $t1, 1              # current sequence length
    li $s2, 1              # max sequence length
    move $s3, $s1          # start of max sequence

find_lis_loop:
    bgt $t0, $s0, check_last
    lw $t2, 0($s1)
    lw $t3, 4($s1)
    ble $t3, $t2, reset_sequence
    addi $t1, $t1, 1
    j next_iteration

reset_sequence:
    blt $t1, $s2, skip_update
    move $s2, $t1
    addi $s3, $s1, 4
skip_update:
    li $t1, 1

next_iteration:
    addi $t0, $t0, 1
    addi $s1, $s1, 4
    j find_lis_loop

check_last:
    blt $t1, $s2, print_result
    move $s2, $t1
    addi $s3, $s1, 4

print_result:
    li $v0, 4
    la $a0, print_msg
    syscall

    li $t0, 4
    mul $t0, $s2, $t0
    sub $s3, $s3, $t0      # $s3 = start of LIS
    li $t0, 1              # loop counter

print_loop:
    bgt $t0, $s2, exit
    lw $a0, 0($s3)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $s3, $s3, 4
    addi $t0, $t0, 1
    j print_loop

input_error:
    li $v0, 4
    la $a0, error_msg
    syscall

exit:
    li $v0, 10
    syscall