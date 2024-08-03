.data
prompt1: .asciiz "Enter a positive integer : "
result: .asciiz "The factorial is : "
newline: .asciiz "\n"

.text 
.globl main

main:
    #prompt user to enter interger
    la $a0 prompt1
    li $v0 4
    syscall

    la $a0 newline
    li $v0 4
    syscall

    #read integer
    li $v0 5
    syscall
    move $a0 $v0     #setting the argument for the factorial function 

    jal factorial
    move $t0 $v0

    la $a0 newline
    li $v0 4
    syscall

    li $v0 4
    la $a0 result
    syscall

    move $a0 $t0
    li $v0 1
    syscall

    li $v0 10
    syscall



# Function to calculate the factorial of a function
factorial:
    #initialising stack space
    addi $sp $sp -8
    sw $ra 4($sp)
    sw $a0 0($sp)

    beq $a0 $zero base_case

    addi $a0 $a0 -1
    jal factorial
    lw $a0 0($sp)
    mul $v0 $v0 $a0
    j end_factorial

base_case:
    li $v0 1

end_factorial:
    lw $ra 4($sp)
    addi $sp $sp 8
    jr $ra
