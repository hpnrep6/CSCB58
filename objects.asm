.data 

.eqv CAR_WIDTH 12 # 3 * 4
.eqv CAR_HIEGHT 24 # 6 * 4
.eqv CAR_OFFSET_ROW 244
.eqv BKG_OFFSET_TOTAL 16384
.eqv BKG_OFFSET_TOTAL_LINES 17408
.eqv DISPLAY_W 256
.eqv DISPLAY_H 256

.eqv cG 0x4BD629

.eqv cB 0x29A2D6

.eqv cR 0xD90202

.eqv cY 0xEBE660

.eqv cHY 0xedf57a

.eqv cZ 0x000000

.eqv cW 0xFFFFFF

.eqv cO 0xe39827

.eqv cC1 0xd7f542

.eqv cC2 0xff0000

.eqv cText 0x68c3fc

.eqv cHeart 0xd61c32

.eqv cSpeedup 0x9f1ac7

.eqv cInvince 0xf2efb3

.eqv cRight 0x1c6ae8

.eqv cLeft 0x1c6beb

.eqv cUp 0x1b66e0

.eqv cDown 0x2169de

.eqv bkg 0x9287A3

cars: .space 256
active: .space 64
activep: .word 0
buffer: .space 20500 # Allocate a bit more than needed to allow writing outside screen
car_draw_arr: .space 48

.eqv HALF_CAR_ARR_SIZE 24
.eqv MAX_OBST_CAR_SPEED 6
.text

# a0 x_loc
# a1 y_loc

.globl init_car_arr

init_car_arr:
	la $t0, car_draw_arr

	la $t1, draw_obst_car_fwd_0
	sw $t1, ($t0)

	la $t1, draw_obst_car_fwd_1
	sw $t1, 4($t0)

	la $t1, draw_obst_car_fwd_2
	sw $t1, 8($t0)

	la $t1, draw_obst_car_fwd_2
	sw $t1, 12($t0)

	la $t1, draw_obst_car_fwd_2
	sw $t1, 16($t0)

	la $t1, draw_obst_car_fwd_2
	sw $t1, 20($t0)

	la $t1, draw_obst_car_bwd_0
	sw $t1, 24($t0)

	la $t1, draw_obst_car_bwd_1
	sw $t1, 28($t0)

	la $t1, draw_obst_car_bwd_2
	sw $t1, 32($t0)

	la $t1, draw_obst_car_bwd_2
	sw $t1, 36($t0)

	la $t1, draw_obst_car_bwd_2
	sw $t1, 40($t0)

	la $t1, draw_obst_car_bwd_2
	sw $t1, 44($t0)

	jr $ra

.globl draw_player_car

# a0 x-left
# a1 y-top
draw_player_car:
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
	
	# Row 1
	li $t4, cG
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	
	# Row 2
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	
	# Row 3
	li $t5, cZ
	li $t6, cB
	addi $t0, $t0, DISPLAY_W
	sw $t5, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t6, 12($t0)
	sw $t6, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t5, 28($t0)
	
	# Row 4
	addi $t0, $t0, DISPLAY_W
	sw $t5, ($t0)
	sw $t4, 4($t0)
	sw $t6, 8($t0)
	sw $t6, 12($t0)
	sw $t6, 16($t0)
	sw $t6, 20($t0)
	sw $t4, 24($t0)
	sw $t5, 28($t0)
	
	# Row 5
	li $t7, cR
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t6, 8($t0)
	sw $t7, 12($t0)
	sw $t7, 16($t0)
	sw $t6, 20($t0)
	sw $t4, 24($t0)
	
	# Row 6
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t7, 12($t0)
	sw $t7, 16($t0)
	sw $t7, 20($t0)
	sw $t4, 24($t0)
	
	# Row 7
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t7, 12($t0)
	sw $t7, 16($t0)
	sw $t7, 20($t0)
	sw $t4, 24($t0)
	
	# Row 8
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t7, 12($t0)
	sw $t7, 16($t0)
	sw $t7, 20($t0)
	sw $t4, 24($t0)
		
	# Row 9
	addi $t0, $t0, DISPLAY_W
	sw $t5, ($t0)
	sw $t4, 4($t0)
	sw $t6, 8($t0)
	sw $t6, 12($t0)
	sw $t6, 16($t0)
	sw $t6, 20($t0)
	sw $t4, 24($t0)
	sw $t5, 28($t0)
	
	# Row 10
	addi $t0, $t0, DISPLAY_W
	sw $t5, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t6, 12($t0)
	sw $t6, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t5, 28($t0)
	
	# Row 10
	addi $t0, $t0, DISPLAY_W
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	
	jr $ra

.globl erase_player_car

# a0 x-left
# a1 y-top
erase_player_car:
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
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	
	# Row 2
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	
	# Row 3
	addi $t0, $t0, DISPLAY_W
	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t4, 28($t0)
	
	# Row 4
	addi $t0, $t0, DISPLAY_W
	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t4, 28($t0)
	
	# Row 5
	li $t7, cR
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	
	# Row 6
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	
	# Row 7
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	
	# Row 8
	addi $t0, $t0, DISPLAY_W
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
		
	# Row 9
	addi $t0, $t0, DISPLAY_W
	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t4, 28($t0)
	
	# Row 10
	addi $t0, $t0, DISPLAY_W
	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t4, 28($t0)
	
	# Row 10
	addi $t0, $t0, DISPLAY_W
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	
	jr $ra
	
.globl draw_divider_white

# a0 x
# a1 y-offset
draw_divider_white:
	blt $a0, $zero, draw_divider_white_exit
	bge $a0, 64, draw_divider_white_exit

draw_divider_white_no_exit:

	move $t0, $s7
	
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	move $t2, $t0
	addi $t2, $t2, BKG_OFFSET_TOTAL_LINES #1634
	
	li $t6, cW
	
loop_draw_divider_white:
	sw $t6, ($t0)
	# sw $t6, 4($t0)
	
	sw $t6, 256($t0)
	# sw $t6, 516($t0)
	
	sw $t6, 512($t0)
	# sw $t6, 1028($t0)
	
	# sw $t6, 1536($t0)
	# sw $t6, 1540($t0)
	
	addi $t0, $t0, 1536 #3584
	
	ble $t0, $t2, loop_draw_divider_white
draw_divider_white_exit:
	jr $ra

.globl erase_divider_white

# a0 x
# a1 y-offset
erase_divider_white:
	blt $a0, $zero, erase_divider_white_exit
	bge $a0, 64, erase_divider_white_exit

	move $t0, $s7
	
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	move $t2, $t0
	addi $t2, $t2, BKG_OFFSET_TOTAL_LINES #32256
	
	li $t6, bkg
	
loop_erase_divider_white:
	sw $t6, ($t0)
	# sw $t6, 4($t0)
	
	sw $t6, 256($t0)
	# sw $t6, 516($t0)
	
	sw $t6, 512($t0)
	# sw $t6, 1028($t0)
	
	# sw $t6, 1536($t0)
	# sw $t6, 1540($t0)
	
	addi $t0, $t0, 1536 #3584
	
	ble $t0, $t2, loop_erase_divider_white
erase_divider_white_exit:
	jr $ra


.globl draw_divider_yellow

draw_divider_yellow:
	move $t0, $s7
	
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	move $t2, $t0
	addi $t2, $t2, BKG_OFFSET_TOTAL
	
	li $t6, cY
	
loop_draw_divider_yellow:
	sw $t6, ($t0)
	sw $t6, 8($t0)
	
	sw $t6, 256($t0)
	sw $t6, 264($t0)
	
	sw $t6, 512($t0)
	sw $t6, 520($t0)
	
	sw $t6, 768($t0)
	sw $t6, 776($t0)
	
	addi $t0, $t0, 1024
	
	ble $t0, $t2, loop_draw_divider_yellow
	jr $ra

.globl erase_divider_yellow

erase_divider_yellow:
	move $t0, $s7
	
	li $t1, 4
	mult $a0, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	li $t1, DISPLAY_W
	mult $a1, $t1
	mflo $t1
	add $t0, $t0, $t1
	
	move $t2, $t0
	addi $t2, $t2, BKG_OFFSET_TOTAL
	
	li $t6, bkg
	
loop_erase_divider_yellow:
	sw $t6, ($t0)
	sw $t6, 8($t0)
	
	sw $t6, 256($t0)
	sw $t6, 264($t0)
	
	sw $t6, 512($t0)
	sw $t6, 520($t0)
	
	sw $t6, 768($t0)
	sw $t6, 776($t0)
	
	addi $t0, $t0, 1024
	
	ble $t0, $t2, loop_erase_divider_yellow
	jr $ra

.globl draw_obst_car_fwd_0

# a0 x
# a1 y
draw_obst_car_fwd_0:
	li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, cO
	li $t4, cHY
	li $t9, cB
	li $v0, cZ
	li $t7, cR
	
	
	blt $t0, $zero, draw_obst_car_fwd_0_no_draw_0
	bge $t0, DISPLAY_W, draw_obst_car_fwd_0_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $v0, 512($t2)
	sw $v0, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $v0, 2304($t2)
	sw $v0, 2560($t2)
	sw $t7, 2816($t2)

draw_obst_car_fwd_0_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_0_no_draw_1
	bge $t0, DISPLAY_W, draw_obst_car_fwd_0_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t9, 768($t2)
	sw $t7, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t7, 1792($t2)
	sw $t9, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)


draw_obst_car_fwd_0_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_0_no_draw_2
	bge $t0, DISPLAY_W, draw_obst_car_fwd_0_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t9, 512($t2)
	sw $t9, 768($t2)
	sw $t3, 1024($t2)
	sw $t7, 1280($t2)

	sw $t7, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t9, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_0_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_0_no_draw_3
	bge $t0, DISPLAY_W, draw_obst_car_fwd_0_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t9, 512($t2)
	sw $t9, 768($t2)
	sw $t3, 1024($t2)
	sw $t7, 1280($t2)

	sw $t7, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t9, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_0_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_0_no_draw_4
	bge $t0, DISPLAY_W, draw_obst_car_fwd_0_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t9, 768($t2)
	sw $t7, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t7, 1792($t2)
	sw $t9, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_0_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_0_no_draw_5
	bge $t0, DISPLAY_W, draw_obst_car_fwd_0_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $v0, 512($t2)
	sw $v0, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $v0, 2304($t2)
	sw $v0, 2560($t2)
	sw $t7, 2816($t2)

draw_obst_car_fwd_0_no_draw_5:
	jr $ra


.globl draw_obst_car_fwd_1

draw_obst_car_fwd_1:
li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, cC1
	li $t4, cHY
	li $t9, cB
	li $v0, cZ
	li $t7, cR
	
	blt $t0, $zero, draw_obst_car_fwd_1_no_draw_0
	bge $t0, DISPLAY_W, draw_obst_car_fwd_1_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $v0, 512($t2)
	sw $v0, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $v0, 2304($t2)
	sw $v0, 2560($t2)
	sw $t7, 2816($t2)

draw_obst_car_fwd_1_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_1_no_draw_1
	bge $t0, DISPLAY_W, draw_obst_car_fwd_1_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t9, 768($t2)
	sw $t7, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t7, 1792($t2)
	sw $t9, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)


draw_obst_car_fwd_1_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_1_no_draw_2
	bge $t0, DISPLAY_W, draw_obst_car_fwd_1_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t9, 512($t2)
	sw $t9, 768($t2)
	sw $t3, 1024($t2)
	sw $t7, 1280($t2)

	sw $t7, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t9, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_1_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_1_no_draw_3
	bge $t0, DISPLAY_W, draw_obst_car_fwd_1_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t9, 512($t2)
	sw $t9, 768($t2)
	sw $t3, 1024($t2)
	sw $t7, 1280($t2)

	sw $t7, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t9, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_1_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_1_no_draw_4
	bge $t0, DISPLAY_W, draw_obst_car_fwd_1_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t9, 768($t2)
	sw $t7, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t7, 1792($t2)
	sw $t9, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_1_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_1_no_draw_5
	bge $t0, DISPLAY_W, draw_obst_car_fwd_1_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $v0, 512($t2)
	sw $v0, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $v0, 2304($t2)
	sw $v0, 2560($t2)
	sw $t7, 2816($t2)

draw_obst_car_fwd_1_no_draw_5:
	jr $ra

.globl draw_obst_car_fwd_2

draw_obst_car_fwd_2:
li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, cC2
	li $t4, cHY
	li $t9, cB
	li $v0, cZ
	li $t7, cR
	
	
	blt $t0, $zero, draw_obst_car_fwd_2_no_draw_0
	bge $t0, DISPLAY_W, draw_obst_car_fwd_2_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $v0, 512($t2)
	sw $v0, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $v0, 2304($t2)
	sw $v0, 2560($t2)
	sw $t7, 2816($t2)

draw_obst_car_fwd_2_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_2_no_draw_1
	bge $t0, DISPLAY_W, draw_obst_car_fwd_2_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t9, 768($t2)
	sw $t7, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t7, 1792($t2)
	sw $t9, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)


draw_obst_car_fwd_2_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_2_no_draw_2
	bge $t0, DISPLAY_W, draw_obst_car_fwd_2_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t9, 512($t2)
	sw $t9, 768($t2)
	sw $t3, 1024($t2)
	sw $t7, 1280($t2)

	sw $t7, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t9, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_2_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_2_no_draw_3
	bge $t0, DISPLAY_W, draw_obst_car_fwd_2_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t9, 512($t2)
	sw $t9, 768($t2)
	sw $t3, 1024($t2)
	sw $t7, 1280($t2)

	sw $t7, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t9, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_2_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_2_no_draw_4
	bge $t0, DISPLAY_W, draw_obst_car_fwd_2_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t9, 768($t2)
	sw $t7, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t7, 1792($t2)
	sw $t9, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

draw_obst_car_fwd_2_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_fwd_2_no_draw_5
	bge $t0, DISPLAY_W, draw_obst_car_fwd_2_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $v0, 512($t2)
	sw $v0, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $v0, 2304($t2)
	sw $v0, 2560($t2)
	sw $t7, 2816($t2)

draw_obst_car_fwd_2_no_draw_5:
	jr $ra

.globl draw_obst_car_bwd_0

draw_obst_car_bwd_0:
	li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, cO
	li $t4, cHY
	li $t9, cB
	li $v0, cZ
	li $t7, cR
	
	blt $t0, $zero, draw_obst_car_bwd_0_no_draw_0
	bge $t0, DISPLAY_W, draw_obst_car_bwd_0_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $v0, 2304($t2)
	sw $v0, 2048($t2)
	sw $t3, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $v0, 512($t2)
	sw $v0, 256($t2)
	sw $t7, ($t2)

draw_obst_car_bwd_0_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_0_no_draw_1
	bge $t0, DISPLAY_W, draw_obst_car_bwd_0_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, 2816($t2)
	sw $t3, 2560($t2)
	sw $t3, 2304($t2)
	sw $t9, 2048($t2)
	sw $t7, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t7, 1024($t2)
	sw $t9, 768($t2)
	sw $t3, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)


draw_obst_car_bwd_0_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_0_no_draw_2
	bge $t0, DISPLAY_W, draw_obst_car_bwd_0_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $t9, 2304($t2)
	sw $t9, 2048($t2)
	sw $t3, 1792($t2)
	sw $t7, 1536($t2)

	sw $t7, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $t9, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_0_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_0_no_draw_3
	bge $t0, DISPLAY_W, draw_obst_car_bwd_0_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $t9, 2304($t2)
	sw $t9, 2048($t2)
	sw $t3, 1792($t2)
	sw $t7, 1536($t2)

	sw $t7, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $t9, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_0_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_0_no_draw_4
	bge $t0, DISPLAY_W, draw_obst_car_bwd_0_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, 2816($t2)
	sw $t3, 2560($t2)
	sw $t3, 2304($t2)
	sw $t9, 2048($t2)
	sw $t7, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t7, 1024($t2)
	sw $t9, 768($t2)
	sw $t3, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_0_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_0_no_draw_5
	bge $t0, DISPLAY_W, draw_obst_car_bwd_0_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $v0, 2304($t2)
	sw $v0, 2048($t2)
	sw $t3, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $v0, 512($t2)
	sw $v0, 256($t2)
	sw $t7, ($t2)


draw_obst_car_bwd_0_no_draw_5:
	jr $ra

.globl draw_obst_car_bwd_1

draw_obst_car_bwd_1:
li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, cC1
	li $t4, cHY
	li $t9, cB
	li $v0, cZ
	li $t7, cR
	
	
	blt $t0, $zero, draw_obst_car_bwd_1_no_draw_0
	bge $t0, DISPLAY_W, draw_obst_car_bwd_1_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $v0, 2304($t2)
	sw $v0, 2048($t2)
	sw $t3, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $v0, 512($t2)
	sw $v0, 256($t2)
	sw $t7, ($t2)

draw_obst_car_bwd_1_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_1_no_draw_1
	bge $t0, DISPLAY_W, draw_obst_car_bwd_1_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, 2816($t2)
	sw $t3, 2560($t2)
	sw $t3, 2304($t2)
	sw $t9, 2048($t2)
	sw $t7, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t7, 1024($t2)
	sw $t9, 768($t2)
	sw $t3, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)


draw_obst_car_bwd_1_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_1_no_draw_2
	bge $t0, DISPLAY_W, draw_obst_car_bwd_1_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $t9, 2304($t2)
	sw $t9, 2048($t2)
	sw $t3, 1792($t2)
	sw $t7, 1536($t2)

	sw $t7, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $t9, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_1_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_1_no_draw_3
	bge $t0, DISPLAY_W, draw_obst_car_bwd_1_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $t9, 2304($t2)
	sw $t9, 2048($t2)
	sw $t3, 1792($t2)
	sw $t7, 1536($t2)

	sw $t7, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $t9, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_1_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_1_no_draw_4
	bge $t0, DISPLAY_W, draw_obst_car_bwd_1_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, 2816($t2)
	sw $t3, 2560($t2)
	sw $t3, 2304($t2)
	sw $t9, 2048($t2)
	sw $t7, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t7, 1024($t2)
	sw $t9, 768($t2)
	sw $t3, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_1_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_1_no_draw_5
	bge $t0, DISPLAY_W, draw_obst_car_bwd_1_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $v0, 2304($t2)
	sw $v0, 2048($t2)
	sw $t3, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $v0, 512($t2)
	sw $v0, 256($t2)
	sw $t7, ($t2)


draw_obst_car_bwd_1_no_draw_5:
	jr $ra

.globl draw_obst_car_bwd_2

draw_obst_car_bwd_2:
li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, cC2
	li $t4, cHY
	li $t9, cB
	li $v0, cZ
	li $t7, cR
	
	
	blt $t0, $zero, draw_obst_car_bwd_2_no_draw_0
	bge $t0, DISPLAY_W, draw_obst_car_bwd_2_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $v0, 2304($t2)
	sw $v0, 2048($t2)
	sw $t3, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $v0, 512($t2)
	sw $v0, 256($t2)
	sw $t7, ($t2)

draw_obst_car_bwd_2_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_2_no_draw_1
	bge $t0, DISPLAY_W, draw_obst_car_bwd_2_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, 2816($t2)
	sw $t3, 2560($t2)
	sw $t3, 2304($t2)
	sw $t9, 2048($t2)
	sw $t7, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t7, 1024($t2)
	sw $t9, 768($t2)
	sw $t3, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)


draw_obst_car_bwd_2_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_2_no_draw_2
	bge $t0, DISPLAY_W, draw_obst_car_bwd_2_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $t9, 2304($t2)
	sw $t9, 2048($t2)
	sw $t3, 1792($t2)
	sw $t7, 1536($t2)

	sw $t7, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $t9, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_2_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_2_no_draw_3
	bge $t0, DISPLAY_W, draw_obst_car_bwd_2_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $t9, 2304($t2)
	sw $t9, 2048($t2)
	sw $t3, 1792($t2)
	sw $t7, 1536($t2)

	sw $t7, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $t9, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_2_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_2_no_draw_4
	bge $t0, DISPLAY_W, draw_obst_car_bwd_2_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t4, 2816($t2)
	sw $t3, 2560($t2)
	sw $t3, 2304($t2)
	sw $t9, 2048($t2)
	sw $t7, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t7, 1024($t2)
	sw $t9, 768($t2)
	sw $t3, 512($t2)
	sw $t3, 256($t2)
	sw $t3, ($t2)

draw_obst_car_bwd_2_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, draw_obst_car_bwd_2_no_draw_5
	bge $t0, DISPLAY_W, draw_obst_car_bwd_2_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, 2816($t2)
	sw $t3, 2560($t2)
	sw $v0, 2304($t2)
	sw $v0, 2048($t2)
	sw $t3, 1792($t2)
	sw $t3, 1536($t2)

	sw $t3, 1280($t2)
	sw $t3, 1024($t2)
	sw $t3, 768($t2)
	sw $v0, 512($t2)
	sw $v0, 256($t2)
	sw $t7, ($t2)


draw_obst_car_bwd_2_no_draw_5:
	jr $ra

.globl erase_obst_car

erase_obst_car:

	li $t0, 4
	mult $t0, $a0
	mflo $t0

	li $t1, DISPLAY_W
	mult $t1, $a1
	mflo $t1

	li $t3, bkg
	
	blt $t0, $zero, erase_obst_car_no_draw_0
	bge $t0, DISPLAY_W, erase_obst_car_no_draw_0

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t3, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

erase_obst_car_no_draw_0:
	addi $t0, $t0, 4

	blt $t0, $zero, erase_obst_car_no_draw_1
	bge $t0, DISPLAY_W, erase_obst_car_no_draw_1

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t3, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

erase_obst_car_no_draw_1:
	addi $t0, $t0, 4

	blt $t0, $zero, erase_obst_car_no_draw_2
	bge $t0, DISPLAY_W, erase_obst_car_no_draw_2

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t3, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

erase_obst_car_no_draw_2:
	addi $t0, $t0, 4

	blt $t0, $zero, erase_obst_car_no_draw_3
	bge $t0, DISPLAY_W, erase_obst_car_no_draw_3

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t3, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

erase_obst_car_no_draw_3:
	addi $t0, $t0, 4

	blt $t0, $zero, erase_obst_car_no_draw_4
	bge $t0, DISPLAY_W, erase_obst_car_no_draw_4

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t3, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

erase_obst_car_no_draw_4:
	addi $t0, $t0, 4

	blt $t0, $zero, erase_obst_car_no_draw_5
	bge $t0, DISPLAY_W, erase_obst_car_no_draw_5

	add $t2, $t0, $t1
	add $t2, $t2, $s7

	sw $t3, ($t2)
	sw $t3, 256($t2)
	sw $t3, 512($t2)
	sw $t3, 768($t2)
	sw $t3, 1024($t2)
	sw $t3, 1280($t2)

	sw $t3, 1536($t2)
	sw $t3, 1792($t2)
	sw $t3, 2048($t2)
	sw $t3, 2304($t2)
	sw $t3, 2560($t2)
	sw $t3, 2816($t2)

erase_obst_car_no_draw_5:
	jr $ra


.globl draw_bkg

draw_bkg:
	move $t0, $s7
	addi $t6, $t0, BKG_OFFSET_TOTAL
	li $t5, bkg

loop_draw_bkg:

	sw $t5, ($t0)
	addi $t0, $t0, 4

	ble $t0, $t6, loop_draw_bkg
	
	jr $ra

update_screen:
	move $t0, $s7
	move $t2, $gp
	addi $t1, $s7, BKG_OFFSET_TOTAL

loop_update_screen:
	lw $t5, ($t0)

	# invert
	# li $t3, 255
	# sub $t5, $t3, $t5

	# sll $t5, $t5, 16
	# srl $t5, $t5, 8

	# red
	# sll $t4, $t5, 16

	# blue
	# sll $t3, $t5, 8
	# srl $t3, $t3, 16
	# move $t5, $t3

	sw $t5, ($t2)
	addi $t0, $t0, 4
	addi $t2, $t2, 4

	ble $t0, $t1, loop_update_screen
	
	jr $ra


update_screen_red:
	move $t0, $s7
	move $t2, $gp
	addi $t1, $s7, BKG_OFFSET_TOTAL

loop_update_screen_red:
	lw $t5, ($t0)

	# red
	sll $t5, $t5, 24
	srl $t5, $t5, 8

	sw $t5, ($t2)
	addi $t0, $t0, 4
	addi $t2, $t2, 4

	ble $t0, $t1, loop_update_screen_red
	
	jr $ra


update_screen_blue:
	move $t0, $s7
	move $t2, $gp
	addi $t1, $s7, BKG_OFFSET_TOTAL

loop_update_screen_blue:
	lw $t5, ($t0)

	sll $t5, $t5, 8
	srl $t5, $t5, 16

	sw $t5, ($t2)
	addi $t0, $t0, 4
	addi $t2, $t2, 4

	ble $t0, $t1, loop_update_screen_blue
	
	jr $ra


.globl draw_heart

# a0 - x
# a1 - y
draw_heart:
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


	li $t4, cR

	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 8($t0)

	jr $ra

.globl erase_heart

# a0 - x
# a1 - y
erase_heart:
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

	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 8($t0)

	jr $ra



.globl draw_heal_heart

# a0 - x
# a1 - y
draw_heal_heart:
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


	li $t4, cHeart

	sw $t4, 4($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 8($t0)

	jr $ra



.globl draw_invince

# a0 - x
# a1 - y
draw_invince:
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


	li $t4, cInvince

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)

	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 8($t0)

	jr $ra

.globl erase_invince

# a0 - x
# a1 - y
erase_invince:
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

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)

	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 8($t0)

	jr $ra

draw_right_arrow:
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


	li $t4, cRight
	li $t7, cW

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t7, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	jr $ra

draw_left_arrow:
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


	li $t4, cLeft
	li $t7, cW

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t7, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	jr $ra

draw_down_arrow:
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


	li $t4, cDown
	li $t7, cW

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t7, 4($t0)
	sw $t4, 8($t0)
	sw $t7, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	jr $ra


draw_up_arrow:
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


	li $t4, cUp
	li $t7, cW

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t7, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t7, 4($t0)
	sw $t4, 8($t0)
	sw $t7, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	jr $ra


erase_arrow:
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

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, ($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	addi $t0, $t0, DISPLAY_W

	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)

	jr $ra