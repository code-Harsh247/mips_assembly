.data 
prompt_rows: .asciiz "Enter no. of rows : "
prompt_cols: .asciiz "Enter no. of columns : "

space: .asciiz " "
newline: .asciiz "\n"

row_count: .word 0
col_count: .word 0

matrix_base: .word 0

.text
.globl main 

main:
    # Prompt to enter rows
    li $v0, 4
    la $a0, prompt_rows
    syscall

    # Read number of rows from user
    li $v0, 5
    syscall
    sw $v0, row_count

    # Prompt to enter columns
    li $v0, 4
    la $a0, prompt_cols
    syscall

    # Read number of columns from user
    li $v0, 5
    syscall
    sw $v0, col_count

    lw $s0, row_count        # Load row count into $s0
    lw $s1, col_count        # Load column count into $s1
    mul $s2, $s0, $s1        # Total number of elements in $s2

    # Allocate memory for the matrix
    li $v0, 9
    mul $a0, $s2, 4          # Allocate space for 4-byte integers
    syscall
    sw $v0, matrix_base      # Store base address of matrix

    lw $s3, matrix_base      # Load base address of matrix
    move $t7, $s3            # Set current address for input

    li $t0, 0                # Initialize element counter

fill_matrix:
    beq $t0, $s2, print_original   # If all elements are filled, proceed to print

    # Prompt for matrix element input
    li $v0, 5
    syscall

    # Store user input into matrix
    sw $v0, 0($t7)

    # Move to the next element
    addi $t0, $t0, 1
    addi $t7, $t7, 4

    j fill_matrix

print_original:
    li $t0, 0                # Reset element counter
    move $t7, $s3            # Reset address pointer to start of matrix

print_matrix:
    beq $t0, $s2, exit       # If all elements are printed, exit

    lw $a0, 0($t7)           # Load element to print
    li $v0, 1
    syscall                  # Print integer

    li $v0, 4
    la $a0, space
    syscall                  # Print space

    # Calculate next row and column positions
    addi $t7, $t7, 4         # Move to the next element
    addi $t0, $t0, 1         # Increment element counter

    # Check if we need to print a newline
    div $t0, $s1
    mfhi $t2                 # Get column index (remainder)
    bnez $t2, print_matrix   # If not at end of row, continue

    # Print newline at the end of a row
    li $v0, 4
    la $a0, newline
    syscall

    j print_matrix

exit:
    li $v0, 10
    syscall
