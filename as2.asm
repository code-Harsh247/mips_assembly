.data
    array:      .word 0:10    
    space:      .asciiz " "   
    newline:    .asciiz "\n"  
    prompt1:    .asciiz "Enter 10 integers:\n"
    prompt2:    .asciiz "Max Heap: "

.text
.globl main

main:
    
    li $v0, 4
    la $a0, prompt1
    syscall

    la $t0, array    
    li $t1, 10       

input_loop:
    li $v0, 5       
    syscall
    sw $v0, 0($t0)   
    addi $t0, $t0, 4
    addi $t1, $t1, -1 
    bnez $t1, input_loop

    # Create maxheap
    la $a0, array   
    li $a1, 10     
    jal create_max_heap

   
    li $v0, 4
    la $a0, prompt2
    syscall

    la $t0, array
    li $t1, 10

print_loop:
    lw $a0, 0($t0)
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t0, $t0, 4
    addi $t1, $t1, -1
    bnez $t1, print_loop

    # Exit program
    li $v0, 10
    syscall

# Function to create max heap
create_max_heap:
    # $a0 = array address, $a1 = size
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0   
    move $s1, $a1   

    # startIdx=(n/2)-1
    srl $t0, $s1, 1  # n/2
    addi $t0, $t0, -1 # (n/2) - 1

create_heap_loop:
    move $a0, $s0    #Array address
    move $a1, $s1    #Size
    move $a2, $t0    #Current index
    jal heapify

    addi $t0, $t0, -1
    bgez $t0, create_heap_loop

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

heapify:
    # $a array address, $a1 size, $a2 i
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $s0, $a0   
    move $s1, $a1   
    move $s2, $a2   

    move $t0, $s2    #largest=i

    # l = 2i + 1
    sll $t1, $s2, 1
    addi $t1, $t1, 1

    # r = 2i + 2
    addi $t2, $t1, 1

    # if l < n && A[l] > A[largest]
    bge $t1, $s1, check_right
    sll $t3, $t1, 2
    add $t3, $s0, $t3
    lw $t3, 0($t3)
    sll $t4, $t0, 2
    add $t4, $s0, $t4
    lw $t4, 0($t4)
    ble $t3, $t4, check_right
    move $t0, $t1

check_right:
    # if r < n && A[r] > A[largest]
    bge $t2, $s1, check_swap
    sll $t3, $t2, 2
    add $t3, $s0, $t3
    lw $t3, 0($t3)
    sll $t4, $t0, 2
    add $t4, $s0, $t4
    lw $t4, 0($t4)
    ble $t3, $t4, check_swap
    move $t0, $t2

check_swap:
    beq $t0, $s2, heapify_end

   
    sll $t1, $s2, 2
    add $t1, $s0, $t1
    sll $t2, $t0, 2
    add $t2, $s0, $t2
    lw $t3, 0($t1)
    lw $t4, 0($t2)
    sw $t4, 0($t1)
    sw $t3, 0($t2)

   
    move $a0, $s0
    move $a1, $s1
    move $a2, $t0
    jal heapify

heapify_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra
