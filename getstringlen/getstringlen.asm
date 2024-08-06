.data 
prompt: .asciiz "Enter string : "
str: .space 16

.text
.globl main

main:

    li $v0 4
    la $a0 prompt 
    syscall

    li $v0 8
    la $a0 str
    la $a1 15
    syscall

    la $a0 str
    jal getStringLen

    #print length
    li $v0 1
    move $a0 $v1
    syscall

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

