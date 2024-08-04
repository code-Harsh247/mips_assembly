.data
str1_prompt: .asciiz "Enter string 1 (max size 5): "
str2_prompt: .asciiz "Enter string 2 (max size 5): "

len_prompt: .asciiz "Length of string : "

str_print: .asciiz "The input strings are : "

newline : .ascii "\n"

str1_len: .word 0
str2_len: .word 0

lcs: .space 20

str1: .space 20 #string max size 5
str2: .space 20 #string max size 5

.text
.globl main

main:
    # Prompt to enter first string 
    la $a0 str1_prompt
    li $v0 4
    syscall

    # Reading 1st string 
    li $v0 8
    la $a0 str1
    li $a1 6
    syscall

    # new line
    la $a0 newline
    li $v0 4
    syscall
    

    # Prompt to enter second string 
    la $a0 str2_prompt 
    li $v0 4
    syscall

    # Reading 2nd string 
    li $v0 8
    la $a0 str2
    li $a1 6
    syscall

    # new line
    la $a0 newline
    li $v0 4
    syscall
    
    #prompt to print input strings
    la $a0 str_print
    li $v0 4
    syscall

    # new line
    la $a0 newline
    li $v0 4
    syscall


    ; #prompt to print string length
    ; li $v1 4
    ; la $a0 len_prompt
    ; syscall

    ; #printing string len
    ; li $v1 1
    ; move $a0 $v0
    ; syscall

    #printing string 1
    li $v0 4
    la $a0 str1
    syscall

    # new line
    la $a0 newline
    li $v0 4
    syscall


    ; #prompt to print string length
    ; li $v1 4
    ; la $a0 len_prompt
    ; syscall

    #printing string len
    li $v1 1
    move $a0 $v0
    syscall

    #printing string 2
    li $v0 4
    la $a0 str2
    syscall

    ; li $v0 10
    ; syscall

    ; la $a0 str1
    ; la $a1 str2
    
    ; jal lcs

    ; la $a0 lcs
    ; li $v0 4
    ; syscall












