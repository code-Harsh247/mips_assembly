.data
    prompt1: .asciiz "Enter string 1 : "
    newline : .asciiz "\n"
    prompt2: .asciiz "Enter string 2 : "
    result: .ascii "The longest common substring is : "

    str1: .space 16 
    str2: .space 16

.text
.globl main

main:
    la $a0 prompt1
    li $v0 4
    syscall

    li $v0 8
    la $a0 str1
    la $a1 15
    syscall 

    la $a0 prompt2
    li $v0 4
    syscall

    li $v0 8
    la $a0 str2
    la $a1 15
    syscall   

    la $a0 str1
    li $v0 4
    syscall

    la $a0 str2
    li $v0 4
    syscall

    la $a0 newline
    li $v0 4
    syscall

    li $v0 10
    syscall 

    



