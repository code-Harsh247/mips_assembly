.data
prompt1: .asciiz "Enter string : "
newline: .asciiz "\n"
output: .asciiz "Output : "

str: .space 25
str_size: .word 0
rev_str: .space 25

.text 
.globl main

main:
    #prompt to enter string
    li $v0 4
    la $a0 prompt1
    syscall

    #reading string from user
    li $v0 8 
    la $a0 str
    la $a1 24
    syscall

    jal getsize

    #printing string length
    li $v0 1
    move $a0 $v1
    syscall

    #storing str size
    la $t0 str_size
    sw $v1 0($t0)

    li $v0 4
    la $a0 newline
    syscall

    jal reverse_string

    la $a0 output
    li $v0 4
    syscall

    la $a0 rev_str
    li $v0 4
    syscall

    li $v0 10
    syscall

#function to get string length
getsize:
    #Loop variable
    li $t0 0
    la $t1 str
    loop:
        lb $t2 0($t1)
        beq $t2, 10, endloop  # Check for newline (ASCII 10)
        beqz $t2 endloop

        addi $t0 $t0 1
        addi $t1 $t1 1

        j loop

    endloop:
        move $v1 $t0
        jr $ra


reverse_string:
    la $t0, str         
    la $t1, rev_str     
    lw $t2, str_size   
    addi $t2, $t2, 1    # Include null terminator in size

    # Push characters onto stack
push_loop:
    lb $t3, 0($t0)      
    addi $sp, $sp, -1   
    sb $t3, 0($sp)      
    addi $t0, $t0, 1    
    addi $t2, $t2, -1   
    bnez $t2, push_loop

    # Pop characters from stack to reverse string
    lw $t2, str_size    
    addi $t2, $t2, 1    

pop_loop:
    lb $t3, 0($sp)     
    sb $t3, 0($t1)      
    addi $sp, $sp, 1    
    addi $t1, $t1, 1    
    addi $t2, $t2, -1   
    bnez $t2, pop_loop  

    jr $ra
        




