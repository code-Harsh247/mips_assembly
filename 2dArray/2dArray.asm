#We use the formula 
# address = base_address + (row * num_columns + column) * 4
# to calculate the address of each element


.data
    prompt_rows: .asciiz "Enter number of rows: "
    prompt_cols: .asciiz "Enter number of columns: "
    prompt_element: .asciiz "Enter element ["
    prompt_element2: .asciiz "]["
    prompt_element3: .asciiz "]: "
    newline: .asciiz "\n"
    space: .asciiz " "

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

    # Calculate total size (rows * columns * 4 bytes per int)
    mul $a0, $s0, $s1
    sll $a0, $a0, 2
    li $v0, 9      # Allocate memory
    syscall
    move $s2, $v0  # $s2 = base address of 2D array

    # Input elements
    move $t0, $zero  # row counter
row_loop:
    move $t1, $zero  # column counter
col_loop:
    # Print prompt
    li $v0, 4
    la $a0, prompt_element
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, prompt_element2
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, prompt_element3
    syscall

    # Get element
    li $v0, 5
    syscall

    # Calculate address and store element
    mul $t2, $t0, $s1
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    add $t2, $t2, $s2
    sw $v0, ($t2)

    addi $t1, $t1, 1
    blt $t1, $s1, col_loop

    addi $t0, $t0, 1
    blt $t0, $s0, row_loop

    # Print the array
    move $t0, $zero  # row counter
print_row_loop:
    move $t1, $zero  # column counter
print_col_loop:
    mul $t2, $t0, $s1
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    add $t2, $t2, $s2
    lw $a0, ($t2)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, space
    syscall

    addi $t1, $t1, 1
    blt $t1, $s1, print_col_loop

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    blt $t0, $s0, print_row_loop

    # Exit program
    li $v0, 10
    syscall