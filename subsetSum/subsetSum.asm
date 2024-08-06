.data
    entr_arr_size: .asciiz "Enter array size: "
    entr_arr: .asciiz "Enter array elements: "
    output_msg: .asciiz "The sum of each subset is: "
    input_msg: .asciiz "Input array: "
    space: .asciiz " "
    newline: .asciiz "\n"
    debug_msg1: .asciiz "Index: "
    debug_msg2: .asciiz ", Sum: "
    debug_msg3: .asciiz "Stored sum: "
    arr_base: .word 0
    arr_size: .word 0
    ans_arr_base: .word 0
    ans_arr_size: .word 0

.text
.globl main

main:
    # Input array size
    li $v0, 4
    la $a0, entr_arr_size
    syscall
    li $v0, 5
    syscall
    sw $v0, arr_size

    # Allocate memory for input array
    move $t0, $v0
    sll $a0, $t0, 2
    li $v0, 9
    syscall
    sw $v0, arr_base

    # Input array elements
    li $v0, 4
    la $a0, entr_arr
    syscall
    li $t0, 0
    lw $t1, arr_size
    lw $t2, arr_base
input_loop:
    beq $t0, $t1, input_done
    li $v0, 5
    syscall
    sw $v0, 0($t2)
    addi $t2, $t2, 4
    addi $t0, $t0, 1
    j input_loop
input_done:

    # Print input array
    li $v0, 4
    la $a0, input_msg
    syscall
    lw $t0, arr_base
    lw $t1, arr_size
print_input_loop:
    beqz $t1, print_input_done
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    j print_input_loop
print_input_done:
    li $v0, 4
    la $a0, newline
    syscall

    # Calculate ans_arr_size (2^n)
    li $t0, 1
    lw $t1, arr_size
    sllv $t0, $t0, $t1
    sw $t0, ans_arr_size

    # Allocate memory for ans_arr
    move $a0, $t0
    sll $a0, $a0, 2
    li $v0, 9
    syscall
    sw $v0, ans_arr_base

    # Call subsetSums
    li $a0, 0  # index
    li $a1, 0  # current sum
    li $a2, 0  # ans_arr index
    jal subsetSums

    # Sort ans_arr (bubble sort for simplicity)
    jal sort_ans_arr

    # Print results
    li $v0, 4
    la $a0, output_msg
    syscall
    jal print_ans_arr

    # Exit program
    li $v0, 10
    syscall

subsetSums:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $a0, 8($sp)
    sw $a1, 4($sp)
    sw $a2, 0($sp)

    # Debug: Print current index and sum
    li $v0, 4
    la $a0, debug_msg1
    syscall
    li $v0, 1
    lw $a0, 8($sp)
    syscall
    li $v0, 4
    la $a0, debug_msg2
    syscall
    li $v0, 1
    lw $a0, 4($sp)
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    lw $t0, arr_size
    beq $a0, $t0, store_sum

    # Include current element
    lw $t1, arr_base
    sll $t2, $a0, 2
    add $t1, $t1, $t2
    lw $t2, 0($t1)
    add $a1, $a1, $t2
    addi $a0, $a0, 1
    jal subsetSums

    # Exclude current element
    lw $a0, 8($sp)
    lw $a1, 4($sp)
    lw $a2, 0($sp)
    addi $a0, $a0, 1
    jal subsetSums

    j subsetSums_return

store_sum:
    lw $t0, ans_arr_base
    lw $t1, 0($sp)  # Load current ans_arr index
    sll $t2, $t1, 2
    add $t0, $t0, $t2
    lw $t3, 4($sp)  # Load current sum
    sw $t3, 0($t0)  # Store sum in ans_arr
    addi $t1, $t1, 1
    sw $t1, 0($sp)  # Update ans_arr index

    # Debug: Print stored sum
    li $v0, 4
    la $a0, debug_msg3
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, newline
    syscall

subsetSums_return:
    lw $ra, 12($sp)
    lw $a2, 0($sp)
    addi $sp, $sp, 16
    jr $ra

sort_ans_arr:
    lw $t0, ans_arr_size
    addi $t0, $t0, -1
outer_loop:
    beqz $t0, sort_done
    li $t1, 0
    lw $t2, ans_arr_base
inner_loop:
    beq $t1, $t0, inner_done
    lw $t3, 0($t2)
    lw $t4, 4($t2)
    ble $t3, $t4, no_swap
    sw $t4, 0($t2)
    sw $t3, 4($t2)
no_swap:
    addi $t2, $t2, 4
    addi $t1, $t1, 1
    j inner_loop
inner_done:
    addi $t0, $t0, -1
    j outer_loop
sort_done:
    jr $ra

print_ans_arr:
    lw $t0, ans_arr_base
    lw $t1, ans_arr_size
print_loop:
    beqz $t1, print_done
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, space
    syscall
    addi $t0, $t0, 4
    addi $t1, $t1, -1
    j print_loop
print_done:
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra