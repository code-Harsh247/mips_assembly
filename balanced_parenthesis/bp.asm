.data 
prompt1: .asciiz "Enter parenthesis string : "
balance: .asciiz "Balanced"
no_balance: .asciiz "Not Balanced"
newline: .asciiz "\n"
str: .space 100

.text
.globl main

main:
    li $v0 4
    la $a0 prompt1
    syscall

    li $v0 8
    la $a0 str
    li $a1 100
    syscall

    la $s0 str
    li $t7 0

check:
    lb $t0 0($s0)
    beqz $t0 end_check
    li $t1 40  # '('
    li $t2 41  # ')'
    li $t3 10  # '\n'
    beq $t0 $t1 push_to_stack
    beq $t0 $t2 pop_from_stack
    beq $t0 $t3 end_check

    addi $s0 $s0 1
    j check
    
push_to_stack:
    addi $sp $sp -4
    addi $t7 $t7 1
    sw $t1 0($sp)
    addi $s0 $s0 1
    j check

pop_from_stack:
    beqz $t7 no_balance_label
    addi $sp $sp 4
    addi $t7 $t7 -1
    addi $s0 $s0 1
    j check

end_check:
    beqz $t7 balanced_label
    
no_balance_label:
    li $v0 4
    la $a0 no_balance
    syscall
    j end_program

balanced_label:
    li $v0 4
    la $a0 balance
    syscall

end_program:
    li $v0 10
    syscall