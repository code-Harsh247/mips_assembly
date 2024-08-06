.data
    prompt1: .asciiz "Enter string 1 : "
    newline : .asciiz "\n"
    prompt2: .asciiz "Enter string 2 : "
    result: .ascii "The longest common substring is : "

    str1: .space 16    # Allocate 16 bytes of space for string 1
    str2: .space 16    # Allocate 16 bytes of space for string 2

    str1_len: .word 0
    str2_len: .word 0

.text
.globl main

main:
    # Print prompt for first string
    la $a0 prompt1
    li $v0 4
    syscall

    # Read first string from user input
    li $v0 8
    la $a0 str1
    la $a1 15          # Allow up to 15 characters (plus null terminator)
    syscall 

    # Print prompt for second string
    la $a0 prompt2
    li $v0 4
    syscall

    # Read second string from user input
    li $v0 8
    la $a0 str2
    la $a1 15          # Allow up to 15 characters (plus null terminator)
    syscall   

    # Print first string
    la $a0 str1
    li $v0 4
    syscall

    # Print second string
    la $a0 str2
    li $v0 4
    syscall

    # Print a newline
    la $a0 newline
    li $v0 4
    syscall

    #get string 1 length
    la $a0 str1
    jal getStringLen

    #print length of string 1
    li $v0 1
    move $a0 $v1
    syscall

    # store string 1 length
    la $t0 str1_len
    sw $v1 0($t0)

    #get string 2 length
    la $a0 str2
    jal getStringLen

    #print length of string 2
    li $v0 1
    move $a0 $v1
    syscall

    # store string 1 length
    la $t0 str2_len
    sw $v1 0($t0)

    # Exit program
    li $v0 10
    syscall

getStringLen:
    li $t1 0
    loop:
        lb $t2 0($a0)
        beqz $t2 end_loop
        li $t3 10       # ASCII code for newline
        beq $t2 $t3 end_loop
        addi $t1 $t1 1
        addi $a0 $a0 1

        j loop
    
    end_loop:
        move $v1 $t1
        jr $ra

lcs:
    lw $s0, str1_len
    lw $s1, str2_len
    addi $s0, $s0, 1
    addi $s1, $s1, 1

    # Calculate total size (rows * columns * 4 bytes per int)
    mul $a0, $s0, $s1
    sll $a0, $a0, 2
    li $v0, 9      # Allocate memory
    syscall
    move $s2, $v0  # $s2 = base address of 2D array

    # Initialize entire array to zero
    move $t0, $zero  # row counter
row_loop:
    move $t1, $zero  # column counter
col_loop:
    # Calculate address
    mul $t2, $t0, $s1
    add $t2, $t2, $t1
    sll $t2, $t2, 2
    add $t2, $s2, $t2
    
    # Store zero
    sw $zero, ($t2)

    # Increment column counter
    addi $t1, $t1, 1
    blt $t1, $s1, col_loop

    # Increment row counter
    addi $t0, $t0, 1
    blt $t0, $s0, row_loop

    # End of initialization

