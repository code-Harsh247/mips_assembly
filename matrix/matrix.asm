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

    #storing total number of elements
    lw $t1 row_count
    lw $t2 col_count
    mul $t0 $t1 $t2
    la $t3 total
    sw $t0 0($t3)
    lw $t7 0($t3)
    sll $t7 $t7 2
    li $v0 9
    move $a0 $t7
    syscall
    la $s0 matrix_base
    sw $v0 0($s0)

    # base address of matrix s0
    # rowcount t1
    # colcount t2

    # Load base address into $s0 for calculation
    lw $s0  0($s0)

    li $t3 0 #outer loop variable (row)
outer_loop:
    beq $t3 $t1 end_outer_loop

    li $t4 0 #inner loop varaible (col)
    inner_loop:
        beq $t4 $t2 end_inner_loop
        
        li $v0 5
        syscall

        #input value in $v0
        # row 
        # calculating address
        # address = base_address + (row * col_count + col)*4

        mul $t0 $t3 $t2
        add $t0 $t0 $t4
        sll $t0 $t0 2
        add $t0 $t0 $s0

        # address in $t0 

        sw $v0 0($t0)

        addi $t4 $t4 1
        j inner_loop

    end_inner_loop:
        addi $t3 $t3 1
        j outer_loop
end_outer_loop:
    #matrix set
    j print_matrix

print_matrix:
    li $t3 0 #outer loop variable (row)
outer_loop2:
    beq $t3 $t1 end_outer_loop2

    li $t4 0 #inner loop varaible (col)
    inner_loop2:
        beq $t4 $t2 end_inner_loop2
        
        #input value in $v0
        # row 
        # calculating address
        # address = base_address + (row * col_count + col)*4

        mul $t0 $t3 $t2
        add $t0 $t0 $t4
        sll $t0 $t0 2
        add $t0 $t0 $s0

        # address in $t0 

        li $v0 1
        lw $t6 0($t0)
        move $a0 $t6
        syscall

        li $v0 4
        la $a0 space
        syscall

        addi $t4 $t4 1
        j inner_loop2

    end_inner_loop2:
        addi $t3 $t3 1

        li $v0 4
        la $a0 newline
        syscall

        j outer_loop2
end_outer_loop2:
    #matrix printed
    li $v0 10
    syscall



        

    
