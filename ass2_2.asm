.data
array:          .word 5, 3, 8, 6, 2, 7, 4, 1, 9, 0
N:              .word 10
K:              .word 3
frequency:      .space 40
result_smallest:.word 0
result_largest: .word 0
prompt:         .asciiz "Enter K :" 
output_smallest:.asciiz "\nKth smallest number is :" 
output_largest: .asciiz "\nKth largest number is " 

.text
.globl main
main:

    # Initialize frequency array to zeros
    la $t0, frequency   # Load address of frequency array into $t0
    li $t1, 0           # Set $t1 to 0 (value to store)
    li $t2, 10          # Set counter for loop (N)

init_freq_loop:
    beq $t2, $zero, fill_frequency   # If counter is 0, go to fill_frequency
    sw $t1, 0($t0)       # Store 0 into current element of frequency array
    addi $t0, $t0, 4     # Move to next element (increment address by 4 bytes)
    addi $t2, $t2, -1    # Decrement counter
    j init_freq_loop     # Jump back to start of loop

fill_frequency:
    li $t2, 10           # Set counter for loop (N)
    la $t0, frequency    # Load address of frequency into $t0
    la $t3, array        # Load address of array into $t3

freq_loop:
    beq $t2, $zero, find_kth_element  # If counter is 0, go to find_kth_element
    lw $t4, 0($t3)       # Load value from array into $t4
    li $t5, 0            # Initialize $t5 to 0 (count of elements less than $t4)
    li $t6, 10           # Set inner loop counter to 10 (N)
    la $t7, array        # Load address of array into $t7

count_less:
    beq $t6, $zero, store_count     # If inner counter is 0, go to store_count
    lw $t8, 0($t7)       # Load value from array into $t8
    addi $t7, $t7, 4     # Move to next element
    addi $t6, $t6, -1    # Decrement inner loop counter
    ble $t8, $t4, inc_count # If $t8 <= $t4, go to inc_count
    j count_less         # Otherwise, go back to count_less

inc_count:
    addi $t5, $t5, 1     # Increment count of elements less than $t4
    j count_less         # Go back to count_less

store_count:
    sw $t5, 0($t0)       # Store count in frequency array
    addi $t0, $t0, 4     # Move to next element in frequency array
    addi $t3, $t3, 4     # Move to next element in array
    addi $t2, $t2, -1    # Decrement outer loop counter
    j freq_loop          # Go back to freq_loop

find_kth_element:
    # Read K
    li $v0, 4            # Load syscall code for printing a string
    la $a0, prompt       # Load address of prompt string
    syscall              # Print the prompt
    li $v0, 5            # Load syscall code for reading an integer into $v0
    syscall              # Read the integer
    move $t5, $v0        # Move read integer from $v0 to $t5

    li $t2, 10           # Set loop counter to 10 (N)
    la $t0, frequency    # Load address of frequency into $t0
    la $t3, array        # Load address of array into $t3

smallest_search:
    beq $t2, $zero, exit # If counter is 0, exit
    lw $t1, 0($t0)       # Load value from frequency into $t1
    lw $t4, 0($t3)       # Load value from array into $t4
    beq $t1, $t5, print_smallest # If $t1 == $t5, go to print_smallest
    addi $t0, $t0, 4     # Move to next element in frequency
    addi $t3, $t3, 4     # Move to next element in array
    addi $t2, $t2, -1    # Decrement loop counter
    j smallest_search    # Go back to smallest_search

print_smallest:
    li $v0, 4            # Load syscall code for printing a string
    la $a0, output_smallest # Load address of output_smallest string
    syscall              # Print output_smallest string
    li $v0, 1            # Load syscall code for printing an integer
    move $a0, $t4        # Move integer to be printed from $t4 to $a0
    syscall              # Print the integer

    # Prepare for largest element search
    li $t2, 10           # Set loop counter to 10 (N)
    la $t0, frequency    # Load address of frequency into $t0
    la $t3, array        # Load address of array into $t3

    # Calculate Kth largest
    li $t6, 10           # Set $t6 to 10 (N)
    sub $t6, $t6, $t5    # Calculate N - K
    addi $t6, $t6, 1     # Add 1 for 0-based index
    move $t5, $t6        # Move result to $t5

largest_search:
    beq $t2, $zero, exit # If counter is 0, exit
    lw $t1, 0($t0)       # Load value from frequency into $t1
    lw $t4, 0($t3)       # Load value from array into $t4
    beq $t1, $t5, print_largest # If $t1 == $t5, go to print_largest
    addi $t0, $t0, 4     # Move to next element in frequency
    addi $t3, $t3, 4     # Move to next element in array
    addi $t2, $t2, -1    # Decrement loop counter
    j largest_search     # Go back to largest_search

print_largest:
    li $v0, 4            # Load syscall code for printing a string
    la $a0, output_largest # Load address of output_largest string
    syscall              # Print output_largest string
    li $v0, 1            # Load syscall code for printing an integer
    move $a0, $t4        # Move integer to be printed from $t4 to $a0
    syscall              # Print the integer

exit:
    li $v0, 10           # Load syscall code for exit
    syscall              # Exit program
