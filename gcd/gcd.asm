.data 
prompt1: .asciiz "Enter num 1 : "
newline: .asciiz "\n"

prompt2: .asciiz "Enter num 2 : "
gcd: .asciiz "GCD is : "

.text
.globl main

main:
    li $v0 4
    la $a0 prompt1
    syscall

    li $v0 5
    syscall
    move $s0 $v0 

    li $v0 4
    la $a0 prompt2
    syscall

    li $v0 5
    syscall
    move $s1 $v0 

loop:
    beqz $s0 return_b
    beqz $s1 return_a
    beq $s1 $s0 return_a

    div $t0 $s0 $s1
    mfhi $t1

    li $t2 0
    blt $t1 $t2 return_b

    move $t3 $t1
    move $s0 $s1
    move $s1 $t3

    j loop

return_b:
    move $v1 $s1
    j end_program

return_a:
    move $v1 $s0
    j end_program

end_program:
    li $v0 4
    la $a0 gcd
    syscall

    li $v0 4
    la $a0 newline
    syscall

    li $v0 1
    move $a0 $v1
    syscall

    li $v0 10
    syscall