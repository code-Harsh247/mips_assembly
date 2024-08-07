.data
    prompt_rows: .asciiz "Enter number of rows: "
    prompt_cols: .asciiz "Enter number of columns: "
    prompt_a: .asciiz "Enter value of a: "
    prompt_b: .asciiz "Enter value of b: "
    prompt_wait: .asciiz "Please wait a few seconds."
    space: .asciiz " "
    newline: .asciiz "\n"
    original_matrix_msg: .asciiz "Original Matrix:\n"
    transpose_matrix_msg: .asciiz "\nTranspose Matrix:\n"
    matrix: .word 0:100  # Assuming max 10x10 matrix (adjust if needed)
    transpose: .word 0:100  # For storing the transpose

.text
.globl main

main:
    # Get number of rows
    li $v0, 4
    la $a0, prompt_rows
    syscall
    li $v0, 5
    syscall
    move $s0, $v0  # $s0 = rows

    # Get number of columns
    li $v0, 4
    la $a0, prompt_cols
    syscall
    li $v0, 5
    syscall
    move $s1, $v0  # $s1 = columns

    # Get value of a
    li $v0, 4
    la $a0, prompt_a
    syscall
    li $v0, 5
    syscall
    move $s2, $v0  # $s2 = a

    # Get value of b
    li $v0, 4
    la $a0, prompt_b
    syscall
    li $v0, 5
    syscall
    move $s3, $v0  # $s3 = b

    # Print original matrix message
    li $v0, 4
    la $a0, original_matrix_msg
    syscall

    # Initialize loop variables
    li $t0, 0  # i = 0
    li $t1, 0  # j = 0

outer_loop:
    beq $t0, $s0, end_outer_loop  # if i == rows, end outer loop

inner_loop:
    beq $t1, $s1, end_inner_loop  # if j == columns, end inner loop

    # Calculate (-1)^(i+j)
    add $t2, $t0, $t1  # $t2 = i + j
    li $t3, 1          # $t3 will hold (-1)^(i+j)
    andi $t4, $t2, 1   # $t4 = (i+j) % 2
    beqz $t4, skip_negate
    li $t3, -1
skip_negate:

    # Calculate a^i
    li $t4, 1          # $t4 will hold a^i
    move $t5, $t0      # $t5 = i (counter)
a_power_loop:
    beqz $t5, end_a_power
    mul $t4, $t4, $s2  # $t4 *= a
    addi $t5, $t5, -1
    j a_power_loop
end_a_power:

    # Calculate b^j
    li $t5, 1          # $t5 will hold b^j
    move $t6, $t1      # $t6 = j (counter)
b_power_loop:
    beqz $t6, end_b_power
    mul $t5, $t5, $s3  # $t5 *= b
    addi $t6, $t6, -1
    j b_power_loop
end_b_power:

    # Calculate final value: (-1)^(i+j) * a^i * b^j
    mul $t3, $t3, $t4  # $t3 *= a^i
    mul $t3, $t3, $t5  # $t3 *= b^j

    # Store value in matrix
    mul $t4, $t0, $s1  # $t4 = i * columns
    add $t4, $t4, $t1  # $t4 += j
    sll $t4, $t4, 2    # $t4 *= 4 (word alignment)
    sw $t3, matrix($t4)

    # Print value
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t1, $t1, 1  # j++
    j inner_loop

end_inner_loop:
    li $v0, 4
    la $a0, newline
    syscall

    li $t1, 0  # Reset j to 0
    addi $t0, $t0, 1  # i++
    j outer_loop

end_outer_loop:
    # Compute and print transpose
    jal compute_transpose

    # Exit program
    li $v0, 10
    syscall

compute_transpose:
    # Print transpose matrix message
    li $v0, 4
    la $a0, transpose_matrix_msg
    syscall

    # Initialize loop variables
    li $t0, 0  # i = 0 (for columns of original matrix)

transpose_outer_loop:
    beq $t0, $s1, end_transpose_outer_loop  # if i == columns, end outer loop

    li $t1, 0  # j = 0 (for rows of original matrix)

transpose_inner_loop:
    beq $t1, $s0, end_transpose_inner_loop  # if j == rows, end inner loop

    # Calculate index in original matrix
    mul $t2, $t1, $s1  # $t2 = j * columns
    add $t2, $t2, $t0  # $t2 += i
    sll $t2, $t2, 2    # $t2 *= 4 (word alignment)

    # Load value from original matrix
    lw $t3, matrix($t2)

    # Calculate index in transpose matrix
    mul $t4, $t0, $s0  # $t4 = i * rows
    add $t4, $t4, $t1  # $t4 += j
    sll $t4, $t4, 2    # $t4 *= 4 (word alignment)

    # Store value in transpose matrix
    sw $t3, transpose($t4)

    # Print value
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t1, $t1, 1  # j++
    j transpose_inner_loop

end_transpose_inner_loop:
    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1  # i++
    j transpose_outer_loop

end_transpose_outer_loop:
    jr $ra  # Return from subroutine