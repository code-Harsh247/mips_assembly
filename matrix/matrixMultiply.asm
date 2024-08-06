.data 
prompt_rows1: .asciiz "Enter no. of rows of MATRIX 1 : "
prompt_cols1: .asciiz "Enter no. of columns of MATRIX 1: "

prompt_rows2: .asciiz "Enter no. of rows of MATRIX 2 : "
prompt_cols2: .asciiz "Enter no. of columns of MATRIX 2: "

invalid_prompt: .asciiz "The number of cols of mat1 is not equal to number of rows of mat2"

prompt_enter1: .asciiz "Enter the elements of mat1 : "
prompt_enter2: .asciiz "Enter the elements of mat2 : "

space: .asciiz " "
newline: .asciiz "\n"

row_count1: .word 0
col_count1: .word 0
row_count2: .word 0
col_count2: .word 0

matrix_base1: .word 0
matrix_base2: .word 0

res_matrix_base: .word 0

.text 
.globl main

main:
    # Prompt to enter rows
    li $v0 4
    la $a0 prompt_rows1
    syscall

    # Read number of rows from user
    li $v0 5
    syscall
    la $t1 row_count1
    sw $v0 0($t1)

    # Prompt to enter columns
    li $v0 4
    la $a0 prompt_cols1
    syscall

    # Read number of rows from user
    li $v0 5
    syscall
    la $t1 col_count1
    sw $v0 0($t1)

    # Prompt to enter rows
    li $v0 4
    la $a0 prompt_rows2
    syscall

    # Read number of rows from user
    li $v0 5
    syscall
    la $t1 row_count2
    sw $v0 0($t1)

    # Prompt to enter columns
    li $v0 4
    la $a0 prompt_cols2
    syscall

    # Read number of rows from user
    li $v0 5
    syscall
    la $t1 col_count2
    sw $v0 0($t1)

    lw $t0 col_count1
    lw $t1 row_count2

    bne $t0 $t1 invalid_sizes

    lw $t0 row_count1
    lw $t1 col_count1
    lw $t2 row_count2
    lw $t3 col_count2

    mul $s0 $t0 $t1
    sll $s0 $s0 2
    li $v0 9
    move $a0 $s0
    syscall
    la $s0 matrix_base1
    sw $v0 0($s0)
    lw $s0 0($s0) #matrix1 base in s0

    mul $s1 $t2 $t3
    sll $s1 $s1 2
    li $v0 9
    move $a0 $s1
    syscall
    la $s1 matrix_base1
    sw $v0 0($s1)
    lw $s1 0($s1) #matrix2 base in s1

    li $t4 0 #outer loop variable (row)

loop1:

    beq $t4 $t0 end_loop1

    li $t5 0 #loop2 variable (col)

    loop2:
        beq $t5 $t1 end_loop2

        # address = base + (row*col_count + col)*4
        move $t6 $t4
        mul $t6 $t6 $t1
        add $t6 $t6 $t5
        sll $t6 $t6 2
        add $t6 $s0 $t6 # address in t6

        li $v0 5
        syscall

        sw $v0 0($t6)

        addi $t5 $t5 1
        j loop2

    end_loop2:

        addi $t4 $t4 1
        j loop1
end_loop1:
    li $v0 4
    la $a0 prompt_enter2
    syscall 

    li $t4 0
    j loop3


loop3:

    beq $t4 $t2 end_loop3

    li $t5 0 #loop2 variable (col)

    loop4:
        beq $t5 $t3 end_loop4

        # address = base + (row*col_count + col)*4
        move $t6 $t4
        mul $t6 $t6 $t1
        add $t6 $t6 $t5
        sll $t6 $t6 2
        add $t6 $s1 $t6 # address in t6

        li $v0 5
        syscall

        sw $v0 0($t6)

        addi $t5 $t5 1
        j loop4

    end_loop4:

        addi $t4 $t4 1
        j loop3

# ... [Previous code remains unchanged] ...

end_loop3:

# Allocate memory for result matrix
mul $s2 $t0 $t3  # rows of mat1 * cols of mat2
sll $s2 $s2 2    # multiply by 4 for byte size
li $v0 9
move $a0 $s2
syscall
la $s2 res_matrix_base
sw $v0 0($s2)
lw $s2 0($s2)    # result matrix base in s2

# Matrix multiplication
li $t4 0  # i for rows of mat1
mult_loop1:
    beq $t4 $t0 end_mult_loop1
    li $t5 0  # j for cols of mat2
    mult_loop2:
        beq $t5 $t3 end_mult_loop2
        li $t6 0  # k for cols of mat1/rows of mat2
        li $t7 0  # sum
        mult_loop3:
            beq $t6 $t1 end_mult_loop3
            
            # Get mat1[i][k]
            mul $t8 $t4 $t1
            add $t8 $t8 $t6
            sll $t8 $t8 2
            add $t8 $s0 $t8
            lw $t8 0($t8)
            
            # Get mat2[k][j]
            mul $t9 $t6 $t3
            add $t9 $t9 $t5
            sll $t9 $t9 2
            add $t9 $s1 $t9
            lw $t9 0($t9)
            
            # Multiply and add to sum
            mul $t8 $t8 $t9
            add $t7 $t7 $t8
            
            addi $t6 $t6 1
            j mult_loop3
        end_mult_loop3:
        
        # Store result in res_matrix
        mul $t8 $t4 $t3
        add $t8 $t8 $t5
        sll $t8 $t8 2
        add $t8 $s2 $t8
        sw $t7 0($t8)
        
        addi $t5 $t5 1
        j mult_loop2
    end_mult_loop2:
    addi $t4 $t4 1
    j mult_loop1
end_mult_loop1:

# Print result matrix
li $v0 4
la $a0 newline
syscall

li $t4 0  # row counter
print_loop1:
    beq $t4 $t0 end_print_loop1
    li $t5 0  # column counter
    print_loop2:
        beq $t5 $t3 end_print_loop2
        
        # Calculate address and load value
        mul $t6 $t4 $t3
        add $t6 $t6 $t5
        sll $t6 $t6 2
        add $t6 $s2 $t6
        lw $a0 0($t6)
        
        # Print integer
        li $v0 1
        syscall
        
        # Print space
        li $v0 4
        la $a0 space
        syscall
        
        addi $t5 $t5 1
        j print_loop2
    end_print_loop2:
    
    # Print newline
    li $v0 4
    la $a0 newline
    syscall
    
    addi $t4 $t4 1
    j print_loop1
end_print_loop1:

# Exit program
li $v0 10
syscall

invalid_sizes:
    li $v0 4
    la $a0 invalid_prompt
    syscall
    
    li $v0 10
    syscall



