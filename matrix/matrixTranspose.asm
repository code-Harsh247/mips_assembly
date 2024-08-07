.data
    prompt_rows: .asciiz "Enter the number of rows: "
    prompt_cols: .asciiz "Enter the number of columns: "
    prompt_element: .asciiz "Enter element ["
    prompt_element2: .asciiz "]["
    prompt_element3: .asciiz "]: "
    space: .asciiz " "
    newline: .asciiz "\n"
    original_msg: .asciiz "Original Matrix:\n"
    transpose_msg: .asciiz "Transpose Matrix:\n"

.text
.globl main

main:
    # Ask for number of rows
    li $v0, 4
    la $a0, prompt_rows
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0  # $s0 = rows
    
    # Ask for number of columns
    li $v0, 4
    la $a0, prompt_cols
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0  # $s1 = columns
    
    # Calculate total elements
    mul $s2, $s0, $s1  # $s2 = total elements
    
    # Allocate memory for matrix
    mul $a0, $s2, 4
    li $v0, 9
    syscall
    move $s3, $v0  # $s3 = base address of matrix
    
    # Input matrix elements
    move $t0, $s3  # $t0 = current address
    li $t1, 0      # $t1 = current element (counter)
    
input_loop:
    beq $t1, $s2, print_original
    
    # Calculate row and column
    div $t1, $s1
    mflo $t2  # $t2 = row
    mfhi $t3  # $t3 = column
    
    # Print prompt
    li $v0, 4
    la $a0, prompt_element
    syscall
    
    li $v0, 1
    move $a0, $t2
    syscall
    
    li $v0, 4
    la $a0, prompt_element2
    syscall
    
    li $v0, 1
    move $a0, $t3
    syscall
    
    li $v0, 4
    la $a0, prompt_element3
    syscall
    
    # Input element
    li $v0, 5
    syscall
    sw $v0, ($t0)
    
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    j input_loop

print_original:
    # Print original matrix
    li $v0, 4
    la $a0, original_msg
    syscall
    
    move $t0, $s3  # $t0 = current address
    li $t1, 0      # $t1 = current row
    
original_row_loop:
    beq $t1, $s0, print_transpose
    li $t2, 0      # $t2 = current column
    
original_col_loop:
    beq $t2, $s1, original_next_row
    
    lw $a0, ($t0)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j original_col_loop
    
original_next_row:
    li $v0, 4
    la $a0, newline
    syscall
    
    addi $t1, $t1, 1
    j original_row_loop

print_transpose:
    # Print transpose matrix
    li $v0, 4
    la $a0, transpose_msg
    syscall
    
    li $t1, 0      # $t1 = current column of original (row of transpose)
    
transpose_row_loop:
    beq $t1, $s1, exit
    li $t2, 0      # $t2 = current row of original (column of transpose)
    
transpose_col_loop:
    beq $t2, $s0, transpose_next_row
    
    # Calculate address: base + (row * cols + col) * 4
    mul $t3, $t2, $s1
    add $t3, $t3, $t1
    mul $t3, $t3, 4
    add $t3, $t3, $s3
    
    lw $a0, ($t3)
    li $v0, 1
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    addi $t2, $t2, 1
    j transpose_col_loop
    
transpose_next_row:
    li $v0, 4
    la $a0, newline
    syscall
    
    addi $t1, $t1, 1
    j transpose_row_loop

exit:
    li $v0, 10
    syscall