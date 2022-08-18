.data

numbers_arr: .space 40

.text

.globl init_numbers

init_numbers: 
    la $t0, numbers_arr

    la $t1, draw_zero
    sw $t1, ($t0)

    la $t1, draw_one
    sw $t1, 4($t0)

    la $t1, draw_two
    sw $t1, 8($t0)

    la $t1, draw_three
    sw $t1, 12($t0)

    la $t1, draw_four
    sw $t1, 16($t0)

    la $t1, draw_five
    sw $t1, 20($t0)

    la $t1, draw_six
    sw $t1, 24($t0)

    la $t1, draw_seven
    sw $t1, 28($t0)

    la $t1, draw_eight
    sw $t1, 32($t0)

    la $t1, draw_nine
    sw $t1, 36($t0)

    jr $ra

.globl draw_number

# a0 - x
# a1 - y
# a2 - number
draw_number:
    move $t7, $ra

    la $t0, numbers_arr
    li $t1, 4
    mult $a2, $t1
    mflo $t1

    add $t1, $t0, $t1
    lw $t0, ($t1)

    jal draw_number_jump
draw_number_jump:
    addi $ra, $ra, 8
    jr $t0

    jr $t7

# a0 - x
# a1 - y
draw_one:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_two:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_three:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)


    jr $ra

# a0 - x
# a1 - y
draw_four:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)

    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, 8($t0)

    jr $ra


# a0 - x
# a1 - y
draw_five:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_six:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra


# a0 - x
# a1 - y
draw_seven:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, 8($t0)

    jr $ra


# a0 - x
# a1 - y
draw_eight:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra


# a0 - x
# a1 - y
draw_nine:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, 8($t0)

    jr $ra


# a0 - x
# a1 - y
draw_zero:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, cText
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)

    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
erase_number:
    move $t0, $s7
	
	# y init
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t2
	add $t0, $t0, $t2
	
	# x init
	li $t3, 4
	mult $t3, $a0
	mflo $t2
	add $t0, $t0, $t2

    
    li $t4, bkg
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)


    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra