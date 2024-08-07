.data 
prompt_rows: .asciiz "Enter no. of rows : "
prompt_cols: .asciiz "Enter no. of columns : "

space: .asciiz " "
newline: .asciiz "\n"

row_count: .word 0
col_count: .word 0

matrix_base: .word 0

total: .word 0

.text
.globl main 

main:
    # Prompt to enter rows
    li $v0 4
    la $a0 prompt_rows
    syscall

    # Read number of rows from user
    li $v0 5
    syscall
    la $t1 row_count
    sw $v0 0($t1)

    # Prompt to enter columns
    li $v0 4
    la $a0 prompt_cols
    syscall

    # Read number of rows from user
    li $v0 5
    syscall
    la $t1 col_count
    sw $v0 0($t1)

    lw $s0 row_count
    lw $s1 col_count
    mul $s2 $s0 $s1 #total in s2
    
    li $v0 9
    move $a0 $s2
    syscall
    sw $v0 matrix_base

    lw $s3 matrix_base # base address
    move $t7 $s3 # current address 

    li $t0 0 

fill_matrix:
    beq $t0 $s2 print_original

    div $t0 $s1
    mflo $t1 # row
    mfhi $t2 # col

    li $v0 5
    syscall

    sw $v0 0($t7)

    addi $t0 $t0 1
    addi $t7 $t7 4

    j fill_matrix

print_original:
    