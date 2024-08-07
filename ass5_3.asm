.data
prompt_row: .asciiz "Enter number of rows : "
prompt_col: .asciiz "Enter number of cols : "

original_prompt: .asciiz "The original matrix is : \n"
transpose_prompt: .asciiz "The transpose matrix is : \n"

newline: .asciiz "\n"
space: .asciiz " "

mat_base: .word 0
res_base: .word 0

row_count: .word 0
col_count: .word 0

.text
.globl main
main:
    # Print prompt for number of rows
    li $v0, 4
    la $a0, prompt_row
    syscall

    # Read number of rows
    li $v0, 5
    syscall
    sw $v0, row_count

    # Print prompt for number of cols
    li $v0, 4
    la $a0, prompt_col
    syscall

    # Read number of cols
    li $v0, 5
    syscall
    sw $v0, col_count

    # Load row_count and col_count
    lw $s0, row_count
    lw $s1, col_count

    # Calculate space required for matrix (rows * cols * 4 bytes per int)
    mul $t0, $s0, $s1
    sll $t0, $t0, 2  # Multiply by 4 (2^2)

    # Allocate space for matrix
    li $v0, 9
    move $a0, $t0
    syscall
    sw $v0, mat_base

    lw $s2, mat_base # Load base address of matrix

    # Fill matrix with values
    li $t0, 0 # Row index

outer_loop:
    beq $t0, $s0, end_outer_loop

    li $t1, 0 # Column index

inner_loop:
    beq $t1, $s1, end_inner_loop

    # Read value from user
    li $v0, 5
    syscall

    # Calculate address and store value
    move $t5, $t0
    mul $t5, $t5, $s1
    add $t5, $t5, $t1
    sll $t5, $t5, 2
    add $t5, $t5, $s2

    sw $v0, 0($t5)

    addi $t1, $t1, 1
    j inner_loop

end_inner_loop:
    addi $t0, $t0, 1
    j outer_loop

end_outer_loop:
    # Print original matrix
    li $v0, 4
    la $a0, original_prompt
    syscall

    j print_matrix

print_matrix:
    li $t0, 0 # Row index

outer_loop_p:
    beq $t0, $s0, end_outer_loop_p

    li $t1, 0 # Column index

inner_loop_p:
    beq $t1, $s1, end_inner_loop_p

    # Calculate address and load value
    move $t5, $t0
    mul $t5, $t5, $s1
    add $t5, $t5, $t1
    sll $t5, $t5, 2
    add $t5, $t5, $s2

    li $v0, 1
    lw $a0, 0($t5)
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t1, $t1, 1
    j inner_loop_p

end_inner_loop_p:
    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    j outer_loop_p

end_outer_loop_p:
    # Get Transpose
    j getTranspose

getTranspose:
    # Allocate space for result matrix (transpose)
    mul $t0, $s0, $s1
    sll $t0, $t0, 2
    li $v0, 9
    move $a0, $t0
    syscall
    sw $v0, res_base

    lw $s3, res_base # Load base address of result matrix

    li $t0, 0 # Row index for transpose

loop1:
    beq $t0, $s0, end_loop1

    li $t1, 0 # Column index for transpose

loop2:
    beq $t1, $s1, end_loop2

    # Address in original matrix
    move $t5, $t0
    mul $t5, $t5, $s1
    add $t5, $t5, $t1
    sll $t5, $t5, 2
    add $t5, $t5, $s2

    # Address in transposed matrix
    move $t6, $t1
    mul $t6, $t6, $s0
    add $t6, $t6, $t0
    sll $t6, $t6, 2
    add $t6, $t6, $s3

    lw $t3, 0($t5)
    sw $t3, 0($t6)

    addi $t1, $t1, 1
    j loop2

end_loop2:
    addi $t0, $t0, 1
    j loop1

end_loop1:
    # Print transpose matrix
    li $v0, 4
    la $a0, transpose_prompt
    syscall

    li $t0, 0 # Row index

outer_loop_t:
    beq $t0, $s1, end_outer_loop_t  # This is correct

    li $t1, 0 # Column index

inner_loop_t:
    beq $t1, $s0, end_inner_loop_t  # Changed $s1 to $s0

    # Calculate address and load value
    move $t5, $t0
    mul $t5, $t5, $s0  # Use $s0 (original row count) as it's now the column count of transpose
    add $t5, $t5, $t1
    sll $t5, $t5, 2
    add $t5, $t5, $s3

    li $v0, 1
    lw $a0, 0($t5)
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t1, $t1, 1
    j inner_loop_t

end_inner_loop_t:
    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    j outer_loop_t

end_outer_loop_t:
    # Exit program
    li $v0, 10
    syscall
