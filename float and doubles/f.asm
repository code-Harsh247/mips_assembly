.data
    num1: .float 8.5    # First floating-point number
    num2: .float 4.2    # Second floating-point number
    result_add: .float 0.0   # To store the result of addition
    result_sub: .float 0.0   # To store the result of subtraction
    result_mul: .float 0.0   # To store the result of multiplication
    result_div: .float 0.0   # To store the result of division

.text
.globl main
main:
    # Load floating-point numbers into registers
    lwc1 $f0, num1        # Load 8.5 into $f0
    lwc1 $f1, num2        # Load 4.2 into $f1

    # Perform floating-point addition
    add.s $f2, $f0, $f1   # $f2 = $f0 + $f1
    swc1 $f2, result_add  # Store the addition result

    # Perform floating-point subtraction
    sub.s $f3, $f0, $f1   # $f3 = $f0 - $f1
    swc1 $f3, result_sub  # Store the subtraction result

    # Perform floating-point multiplication
    mul.s $f4, $f0, $f1   # $f4 = $f0 * $f1
    swc1 $f4, result_mul  # Store the multiplication result

    # Perform floating-point division
    div.s $f5, $f0, $f1   # $f5 = $f0 / $f1
    swc1 $f5, result_div  # Store the division result

    # Exit program
    li $v0, 10
    syscall
