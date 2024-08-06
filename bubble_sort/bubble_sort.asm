.data
prompt1 : .asciiz "Enter size of array : "
prompt2 : .asciiz "Enter array elements: "
print_arr: .asciiz "The input array is : "
newline : .asciiz "\n"

arr_base: .word 0
arr_size: .word 0

.text
.globl main

main:
    # Prompt to enter size of array
    la $a0, prompt1
    li $v0, 4
    syscall

    # Taking the user input for size of array
    li $v0, 5
    syscall
    move $t0, $v0

    # Store arr_size to memory
    la $t1, arr_size
    sw $t0, 0($t1)

    # Calculate memory needed
    li $t1, 4
    mul $t1, $t0, $t1

    # Allocating memory using sbrk 
    li $v0, 9
    move $a0, $t1
    syscall
    move $t2, $v0 # $t2 has base address of the allocated memory

    # Store the base address in memory
    la $t3, arr_base
    sw $t2, 0($t3)

    # Initialise loop variable to 0
    li $t3, 0 

    # Prompt to enter array elements
    la $a0, prompt2
    li $v0, 4
    syscall

    # Newline
    la $a0, newline
    li $v0, 4
    syscall

initialise_loop:
    bge $t3, $t0, print_array

    li $v0, 5
    syscall

    sw $v0, 0($t2)

    addi $t2, $t2, 4
    addi $t3, $t3, 1

    j initialise_loop

print_array:
    # Prompt to print array
    la $a0, print_arr
    li $v0, 4
    syscall

    # Newline
    la $a0, newline
    li $v0, 4
    syscall

    # Initialising loop variable
    li $t3, 0

    # Loading base address and size of array from memory
    lw $t1, arr_base
    lw $t2, arr_size

    print_loop:
        bge $t3, $t2, end_print_loop

        # Print array element
        li $v0, 1
        lw $a0, 0($t1)
        syscall

        addi $t1, $t1, 4
        addi $t3, $t3, 1

        j print_loop
    
    end_print_loop:
        lw $t0, arr_size
        li $t1, 0
        # Newline
        la $a0, newline
        li $v0, 4
        syscall
        j bubble_sort

bubble_sort:
    lw $t0, arr_size    # Reload size of array
    lw $t5, arr_base    # Reload base address of array

    outer_loop:
        bge $t1, $t0, end_outer_loop
        li $t2, 0        # No swaps initially

        li $t3, 0
        addi $t4, $t0, -1
        sub $t4, $t4, $t1

        inner_loop:
            bge $t3, $t4, end_inner_loop

            lw $t5, arr_base
            sll $t6, $t3, 2    # $t6 = index * 4
            add $t6, $t5, $t6  # Address of arr[i]
            lw $t8, 0($t6)     # arr[i]
            lw $t9, 4($t6)     # arr[i+1]

            bge $t8, $t9, no_swap

            # Swap arr[i] and arr[i+1]
            sw $t9, 0($t6)     # Store arr[i+1] at arr[i]
            sw $t8, 4($t6)     # Store arr[i] at arr[i+1]
            li $t2, 1          # Set swap flag

            no_swap:
            addi $t3, $t3, 1
            j inner_loop
        
        end_inner_loop:
            addi $t1, $t1, 1
            beqz $t2, end_outer_loop
            j outer_loop
    
    end_outer_loop:
        # Print sorted array
        lw $t1, arr_base
        lw $t2, arr_size

        print_sorted_loop:
            bge $t3, $t2, end_program

            # Print array element
            li $v0, 1
            lw $a0, 0($t1)
            syscall

            # Newline
            la $a0, newline
            li $v0, 4
            syscall

            addi $t1, $t1, 4
            addi $t3, $t3, 1

            j print_sorted_loop

end_program:
    li $v0, 10
    syscall
