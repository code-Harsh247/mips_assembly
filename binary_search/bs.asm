.data
prompt1 : .asciiz "Enter size of array : "
prompt2 : .asciiz "Enter array elements in sorted order. : "
prompt3 : .asciiz "Enter Query : "
prompt4 : .asciiz "The index of the query in the array : "
prompt5 : .asciiz "Element not found."

print_arr: .asciiz "The input array is : "
newline : .asciiz "\n"

arr_base: .word 0
arr_size: .word 0
query: .word 0

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

    #storing arr_size to memory
    la $t1 arr_size
    sw $t0 0($t1)

    # calculate memory needed
    li $t1 4
    mul $t1 $t0 $t1

    # Allocating memory using sbrk 
    li $v0 9
    move $a0 $t1
    syscall
    move $t2 $v0 #t2 has base address of the allocated memory

    #store the base address in memory
    la $t3 arr_base
    sw $t2 0($t3)

    #initialise loop varible to 0
    li $t3 0 

    #prompt to enter array elements
    la $a0 prompt2
    li $v0 4
    syscall

    #newline
    la $a0 newline
    li $v0 4
    syscall

initialise_loop:
    bge $t3 $t0 print_array

    li $v0 5
    syscall

    sw $v0 0($t2)

    addi $t2 $t2 4
    addi $t3 $t3 1

    j initialise_loop

print_array:
    #prompt to print array
    la $a0, print_arr
    li $v0, 4
    syscall

    #newline
    la $a0 newline
    li $v0 4
    syscall

    #initialising loop variable
    li $t3 0

    #loading base address and size of array from memory
    lw $t1 arr_base
    lw $t2 arr_size

    print_loop:
        bge $t3 $t2 end_print_loop

        #print array element
        li $v0 1
        lw $a0 0($t1)
        syscall

        #newline
        la $a0 newline
        li $v0 4
        syscall

        addi $t1 $t1 4
        addi $t3 $t3 1

        j print_loop
    
    end_print_loop:
        j enter_query

enter_query:
    #prompt to enter query
    la $a0 prompt3
    li $v0 4
    syscall

    #reading query 
    li $v0 5
    syscall
    move $t1 $v0

    #storing query in memory
    la $t2 query
    sw $t1 0($t2)

    jal binary_search

    li $t0 -1
    beq $v1 $t0 print_not_found
    j found

    print_not_found:
        li $v0 4
        la $a0 prompt5
        syscall
        j end_program
    
    found:
        li $v0 4
        la $a0 prompt4
        syscall

        li $v0 4
        la $a0 newline
        syscall

        move $a0 $v1
        li $v0 1
        syscall

        j end_program
    


binary_search:
    lw $t0 arr_base # arr base address t0
    lw $t1 arr_size # arr size         t1
    lw $t2 query    # query            t2
    li $t3 0        # l                t3
    addi $t4 $t1 -1 # r                t4
    li $t5 -1       # ans              t5

    while_loop: 
        bgt $t3 $t4 end_while_loop
        add $t6 $t4 $t3 # l+r          t6
        srl $t7, $t6, 1 #(l+r)/2
        
        sll $t6, $t7, 2      # mid * 4
        add $t6 $t6 $t0      
        lw $t8 0($t6)        # arr[mid]     $t8

        beq $t8 $t2 return_mid #if(arr[mid] == query)
        blt $t8 $t2 go_right   #if(arr[mid] < query)

        go_left:
            addi $t4 $t7 -1
            j while_loop

        go_right:
            addi $t3 $t7 1
            j while_loop

        return_mid:
            move $t5 $t7
            j end_while_loop

    end_while_loop:
        move $v1 $t5
        jr $ra


end_program:
    li $v0 10
    syscall


    




    
    







    


