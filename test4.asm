.data
    bin:            .space 128
    num_msg:        .asciiz "Enter M,d,N: "
    print_bin_msg:  .asciiz "The exponent in binary is: "
    print_exp_msg:  .asciiz "The exponentiation value of : "
    space:          .asciiz " "
    newline:        .asciiz "\n"

.text
.globl main

main:
    # Print input prompt
    li $v0, 4
    la $a0, num_msg
    syscall

    # Input M, d, N
    li $v0, 5
    syscall
    move $s0, $v0   # s0 = M

    li $v0, 5
    syscall
    move $s1, $v0   # s1 = d

    li $v0, 5
    syscall
    move $s2, $v0   # s2 = N

    # Convert d to binary
    jal DecimalToBinary

    # Print binary representation
    jal PrintBinary

    # Perform modular exponentiation
    jal ModExp

    # Exit program
    li $v0, 10
    syscall

DecimalToBinary:
    li $t0, 124     # Start index for binary array
    move $t1, $s1   # t1 = d

convert_loop:
    beqz $t1, convert_end
    andi $t2, $t1, 1
    sw $t2, bin($t0)
    srl $t1, $t1, 1
    addi $t0, $t0, -4
    j convert_loop

convert_end:
    move $s3, $t0   # Save start index of binary
    jr $ra

PrintBinary:
    li $v0, 4
    la $a0, print_bin_msg
    syscall

    addi $t0, $s3, 4

print_loop:
    bge $t0, 128, print_end
    lw $a0, bin($t0)
    li $v0, 1
    syscall
    addi $t0, $t0, 4
    j print_loop

print_end:
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

ModExp:
    move $t0, $s0   # t0 = S = M
    addi $t1, $s3, 4

mod_exp_loop:
    bge $t1, 128, mod_exp_end
    
    # Square
    mul $t2, $t0, $t0
    div $t2, $s2
    mfhi $t0
    
    # Multiply if bit is 1
    lw $t3, bin($t1)
    bnez $t3, multiply
    j next_bit

multiply:
    mul $t2, $t0, $s0
    div $t2, $s2
    mfhi $t0

next_bit:
    addi $t1, $t1, 4
    j mod_exp_loop

mod_exp_end:
    # Print result
    li $v0, 4
    la $a0, print_exp_msg
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    jr $ra