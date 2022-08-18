.data
letters_arr: .space 104

.text

.macro init_draw_letter
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
.end_macro

.globl init_letters

init_letters:
    la $t0, letters_arr

    la $t1, draw_A
    sw $t1, ($t0)

    la $t1, draw_B
    sw $t1, 4($t0)

    la $t1, draw_C
    sw $t1, 8($t0)

    la $t1, draw_D
    sw $t1, 12($t0)

    la $t1, draw_E
    sw $t1, 16($t0)

    la $t1, draw_F
    sw $t1, 20($t0)

    la $t1, draw_G
    sw $t1, 24($t0)

    la $t1, draw_H
    sw $t1, 28($t0)

    la $t1, draw_I
    sw $t1, 32($t0)

    la $t1, draw_J
    sw $t1, 36($t0)

    la $t1, draw_K
    sw $t1, 40($t0)

    la $t1, draw_L
    sw $t1, 44($t0)

    la $t1, draw_M
    sw $t1, 48($t0)

    la $t1, draw_N
    sw $t1, 52($t0)

    la $t1, draw_O
    sw $t1, 56($t0)

    la $t1, draw_P
    sw $t1, 60($t0)

    la $t1, draw_Q
    sw $t1, 64($t0)

    la $t1, draw_R
    sw $t1, 68($t0)

    la $t1, draw_S
    sw $t1, 72($t0)

    la $t1, draw_T
    sw $t1, 76($t0)

    la $t1, draw_U
    sw $t1, 80($t0)

    la $t1, draw_V
    sw $t1, 84($t0)

    la $t1, draw_W
    sw $t1, 88($t0)

    la $t1, draw_X
    sw $t1, 92($t0)
    
    la $t1, draw_Y
    sw $t1, 96($t0)

    la $t1, draw_Z
    sw $t1, 100($t0)

    jr $ra

.globl draw_string

# a0 - x
# a1 - y
# a2 - len
# a3 - addr
draw_string:
    move $t8, $ra
    sll $a2, $a2, 2
    add $t5, $a3, $a2

draw_string_loop:
    lw $a2, ($a3)
    addi $a2, $a2, -97
    jal draw_letter
    
    addi $a3, $a3, 4 
    addi $a0, $a0, 4

    bne $a3, $t5, draw_string_loop

    jr $t8


.globl draw_letter

# a0 - x
# a1 - y
# a2 - letter
draw_letter:
    move $t7, $ra

    la $t0, letters_arr
    li $t1, 4
    mult $a2, $t1
    mflo $t1

    add $t1, $t0, $t1
    lw $t0, ($t1)

    jal draw_letter_jump
draw_letter_jump:
    addi $ra, $ra, 8
    jr $t0

    jr $t7

# a0 - x
# a1 - y
draw_A:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_B:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_C:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_D:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_E:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_F:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    # sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_G:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    #sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_H:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_I:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    # sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    # sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    # sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_J:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    # sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    # sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    # sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_K:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_L:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)

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
draw_M:
    init_draw_letter
    
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

# a0 - x
# a1 - y
draw_N:
    init_draw_letter
    
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
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_O:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_P:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
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

    jr $ra

# a0 - x
# a1 - y
draw_Q:
    init_draw_letter
    
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
draw_R:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, ($t0)
    sw $t4, 4($t0)
    # sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    # sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_S:
    init_draw_letter
    
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
draw_T:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

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
    sw $t4, 4($t0)

    jr $ra

# a0 - x
# a1 - y
draw_U:
    init_draw_letter
    
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
draw_V:
    init_draw_letter
    
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
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, 4($t0)

    jr $ra

# a0 - x
# a1 - y
draw_W:
    jr $ra

# a0 - x
# a1 - y
draw_X:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 8($t0)

    jr $ra

# a0 - x
# a1 - y
draw_Y:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, ($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, 4($t0)

    jr $ra

# a0 - x
# a1 - y
draw_Z:
    init_draw_letter
    
    # Row 1
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 2
    sw $t4, 8($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 3
    sw $t4, 4($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 4
    sw $t4, ($t0)

    addi $t0, $t0, DISPLAY_W

    # Row 5
    sw $t4, ($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)

    jr $ra


