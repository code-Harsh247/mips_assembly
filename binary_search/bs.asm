.data
prompt1 : .asciiz "Enter size of array : "
prompt2 : .asciiz "Enter array elements in sorted order. : "
prompt3 : .asciiz "Enter Query : "
prompt4 : .asciiz "The index of the query in the array : "
prompt5 : .asciiz "Element not found."
newline : .asciiz "\n"

.text
.globl main

main:
    # Prompt to enter size of array
    la $a0 prompt1
    li $v0 4
    syscall

    # Taking the user input for size of array
    li $v0 5
    syscall
    move $t0 $v0

    # calculate memory needed
    li $t1 4
    mul $t1 $t0 $t1

    # Allocating memory using sbrk 
    li $v0 9
    move $a0 $t1
    syscall
    move $t2 $v0 #t2 has base address of the allocated memory

    li $t3 0 #initialise loop varible to 0

    la $a0 prompt2
    li $v0 4
    syscall

    la $a0 newline
    li $v0 4
    syscall

initialise_loop:
    bge $t3 $t0 end_init_loop

    li $v0 5
    syscall

    sw $v0 0($t2)

    addi $t2 $t2 4
    addi $t3 $t3 1

    j initialise_loop

end_init_loop:
    li $v0 10
    syscall



    


