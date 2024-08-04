.data
    count: .asciiz "Enter the number of terms: "
    terms: .asciiz "The Fibonacci sequence is: "
    newline: .asciiz "\n"
    tab_sp: .asciiz "\t"
    term_count: .word 0

.text
.globl main

main:
    # Print prompt for the number of terms
    li $v0, 4
    la $a0, count
    syscall

    # Read the number of terms from user input
    li $v0, 5
    syscall

    # Store the term count
    la $t0, term_count
    sw $v0, 0($t0)

    # Print the Fibonacci sequence prompt
    li $v0, 4
    la $a0, terms
    syscall

    # Load the number of terms into $t1
    lw $t1, term_count

    # Initialize first two Fibonacci numbers
    li $t2, 0    # F0 = 0
    li $t3, 1    # F1 = 1

    # Print the Fibonacci sequence iteratively
    li $t0, 0    # Loop counter

print_fibo_seq:
    bge $t0, $t1, end_print_loop  # End if all terms are printed

    # Print current Fibonacci number ($t2)
    li $v0, 1
    move $a0, $t2
    syscall

    # Print tab space between numbers
    li $v0, 4
    la $a0, tab_sp
    syscall

    # Compute the next Fibonacci number
    add $t4, $t2, $t3  # $t4 = F(n) + F(n+1)
    move $t2, $t3      # $t2 = F(n+1)
    move $t3, $t4      # $t3 = F(n+2)

    # Increment loop counter
    addi $t0, $t0, 1
    j print_fibo_seq

end_print_loop:
    li $v0, 10  # Exit program
    syscall
