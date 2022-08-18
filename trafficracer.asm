###################################################################### 
# CSCB58 Summer 2022 Project 
# University of Toronto, Scarborough 
# 
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 
# 
# Basic features that were implemented successfully 
# - Basic feature a: displaying number of lives
#		The lives are displayed as hearts at the top left of the screen
#
# - Basic feature b: different cars moving at different speeds
# 		There are 6 different possible speeds for the cars, ranging from 1 unit per 2 frames
#		to 6 units per 2 frames.
#
# - Basic feature c: game over
#		When the player's reaches 0 lives, the game brings them to the game over screen after
#		the damage indication effect completes (flashing red). The player is then shown the option
#		to either restart the game or to return to the main menu.
# 
# Additional features that were implemented successfully 
# - Additional feature a: pickups
#		There are 3 types of pickups, extra lives, invincibility, and velocity boosts
#		1) Extra lives are represented as red hearts and give the player an extra life
#		2) Invincibility is represented as a yellow shield and makes the player immune to any cars and pickups.
#		This effect is indicated by a blue filter on the screen.
#		3) Directional boosts are represented by blue circles with white arrows in them, indicating the
#		direction of the boost. When the player runs over one of them, the player is boosted in that direction.
#
# - Additional feature b: live score
#		The player's score is displayed as an 8 digit number at the bottom right of the screen. This
# 		value is reset if the player collides with a car or the side of the road.
#
# - Additional feature c: more challenging level
#		If the player reaches 3000 points, the player enters level 2 where the spawn rate of the
#		cars are set to the max. This makes it more difficult to survive in this level as there'll
# 		be more obstacles to avoid. If the player hits an obstacle, the player is sent back to level
#		1 until they reach 3000 points again.
#  
# Link to the video demo 
# - https://youtu.be/qKuGlL03JkE
# 
# Any additional information that the TA needs to know: 
# 
#	Controls: 
#		WASD to move
#		R to restart
#		Q to start the game
#		E to go to start screen
#
#	Game mechanics:
#		Speed of car: The speed of the car depends on the position the player is in.
#					  As the player moves up the screen, the car moves faster. This speed
#					  is reflected in the road lines, the position of other cars, and the positiion of pickups.
#
#		Collision: When the player collides with the side of the road or a car, the player
#				   has a force applied to it that sends it towards the starting position.
#				   A red flashing effect is used to indicate damage to the player.
#
#		Camera: The game uses a moveable camera system when rendering the objects to allow
#				the use of a larger playable area for the player.
#
#		Points: The points the player has is determined by the distance they travel.
#
#
###################################################################### 
 


.text
.globl main

main:
	j start_screen

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
.data

speed_fwd_0: .float 0.5
speed_fwd_1: .float 1.5
speed_fwd_2: .float 2.5
speed_fwd_3: .float 3.5
out_of_bounds_y: .float 64
obs_arr: .space 800 # 36 * 10

.eqv NUM_OBS 20
.eqv SIZE_OBS 40
.eqv OBS_ARR_SIZE 800
.eqv OUT_OF_BOUNDS_Y 64
# struct obs {
# 0		flip
# 4		UNUSED float loc_y
# 8		addr draw_call
# 12    addr erase_call
# 16	UNUSED addr col_call
# 20	vel
# 24	int active
# 28	int int_loc_x
# 32	int int_loc_y
# 36    int lane
# } 40

.text

.globl init_all_obs

init_all_obs:
    move $t7, $ra

    li $a0, 0
    la $a1, draw_obst_car_fwd_0
    la $a2, erase_obst_car
    li $a3, 0

    jal init_obs

    li $a0, 1
    jal init_obs

    li $a0, 2
    jal init_obs
    
    li $a0, 3
    jal init_obs

    li $a0, 4
    jal init_obs

    li $a0, 5
    jal init_obs

    li $a0, 6
    jal init_obs

    li $a0, 7
    jal init_obs

    li $a0, 8
    jal init_obs

    li $a0, 9
    jal init_obs

    li $a0, 10
    jal init_obs

    li $a0, 11
    jal init_obs

    li $a0, 12
    jal init_obs

    li $a0, 13
    jal init_obs

    li $a0, 14
    jal init_obs
    
    li $a0, 15
    jal init_obs

    jr $t7

.globl init_obs

# a0 obs_num
# a1 addr_drall_call
# a2 addr_erase_call
# a3 addr_col_call
init_obs:
    la $t0, obs_arr
    li $t5, SIZE_OBS
    mult $a0, $t5
    mflo $t1
    add $t0, $t0, $t1

    # x
    li $t2, 2
    sw $t2, 28($t0)

    # y
    lw $t2, out_of_bounds_y
    sw $t2, 4($t0)

    sw $a1, 8($t0)
    sw $a2, 12($t0)
    sw $a3, 16($t0)

    li $t2, 0
    sw $t2, ($t0)
    sw $t2, 20($t0)
    sw $t2, 24($t0)
    sw $t2, 32($t0)
    sw $t2, 36($t0)

    jr $ra
    
.globl move_obs

# a0 obs_num
move_obs:
    la $t0, obs_arr
    li $t5, SIZE_OBS
    mult $a0, $t5
    mflo $t1
    add $t0, $t0, $t1

    lw $t1, 24($t0)
    beq $t1, 0, move_obs_exit
    lw $t1, ($t0)
    beq $t1, 0, move_obs_flip_exit
    li $t1, 0
    sw $t1, ($t0)

    # move y fwd
    lw $t2, 20($t0)
    lw $t3, 32($t0)
    add $t3, $t3, $t2
    add $t3, $t3, $s4
    
    sw $t3, 32($t0)

    blt $t3, OUT_OF_BOUNDS_Y, move_obs_no_set_inactive_bot

    sw $zero, 24($t0)

move_obs_no_set_inactive_bot:
    bgt $t3, -12, move_obs_exit
    sw $zero, 24($t0)

move_obs_exit:
    jr $ra

move_obs_flip_exit:
    li $t1, 1
    sw $t1, ($t0)
    jr $ra
.data

nLine: .asciiz "\n"

p_loc_x: .float 52
p_loc_y: .float 32
p_vel_x: .float 0
p_vel_y: .float 0
p_int_loc_x: .word 52
p_int_loc_y: .word 32
p_lives: .word 3
p_int_vel_x: .word 0

i_p_loc_x: .float 52
i_p_loc_y: .float 32

p_invince_timer: .word 0
p_uwu_timer: .word 0
p_should_reset: .word 0

f_def_fwd: .float 1.6
f_def_bwd: .float -1.6
f_acc_fwd: .float 1.2
f_acc_bwd: .float -1.2
f_x_acc_fwd: .float 1.3
f_x_acc_bwd: .float -1.3
f_decc: .float 1.3
f_zero: .float 0.0
f_max_x: .float 91.0
f_max_y: .float 52.0
f_bounce_x_right: .float 19.0
f_bounce_x_left: .float -19.0
f_mid_x: .float 45.0
f_mid_y: .float 50.0
f_dampening: .float 2.6
f_arrow_bounce_pos: .float 10.0
f_arrow_bounce_neg: .float -10.0

.eqv MAX_X 91
.eqv MAX_Y 52

g_effect: .word 0
g_flip: .word 0
g_level: .word 1
g_erase_hearts: .word 0
g_erase_invince: .word 0
g_erase_arrows: .word 0
g_player_mid: .word 0

.eqv WHITE_LINE_INTERVAL 6
.eqv FRAME_DELAY 10
.eqv SFX_DELAY 30
.eqv INVINCE_TIME 150
.eqv MIN_COOLDOWN 20

time: .word 0

keyDown: .word 0

.eqv key_is_down 0xffff0000
.eqv CAMERA_MAX_X 35

start_msg_0: .word 116, 097, 099, 111, 119, 114, 097, 099, 101, 114
start_msg_1: .word 112, 114, 101, 115, 115, 119, 113, 119, 116, 111, 119,
start_msg_11: .word 115, 116, 097, 114, 116
start_msg_2: .word 112, 114, 101, 115, 115, 119, 114, 119, 116, 111, 119, 
start_msg_22: .word 114, 101, 115, 116, 097, 114, 116, 119, 103, 097, 109, 101
start_msg_3: .word 112 114 101 115 115 119 101 119 102 111 114 119
start_msg_33: .word 115 116 097 114 116 119 115 099 114 101 101 110

death_msg_0: .word 121 111 117 119 099 114 097 115 104 101 100

# s0 time
# s1 camera x
# s2 car spawn cooldown
# s3 level
# s4 speed
# s5 SFX_timer
# s6 death_timer
# s7 buffer

.text

.globl start_screen

start_screen:
	la $s7, buffer
	li $s1, 0 # Camera x
	li $s2, 20
	li $s3, 0 # level
	li $s4, 1
	li $s6, SFX_DELAY

	jal init_all_obs

	jal init_numbers

	jal init_letters

	jal draw_bkg

	jal init_car_arr

	lw $t0, i_p_loc_x
	sw $t0, p_loc_x

	lw $t0, i_p_loc_y
	sw $t0, p_loc_y

	lw $t0, f_zero
	sw $t0, p_vel_x
	sw $t0, p_vel_y

	li $t0, 52
	sw $t0, p_int_loc_x

	li $t0, 32
	sw $t0, p_int_loc_y

	li $t0, 3
	sw $t0, p_lives

	li $s0, 1 # time

start_screen_loop:
	jal capture_key

	li $a0, 5
	li $a1, 5
	li $a2, 10
	la $a3, start_msg_0
	jal draw_string

	li $a0, 5
	li $a1, 18
	li $a2, 11
	la $a3, start_msg_1
	jal draw_string


	li $a0, 5
	li $a1, 24
	li $a2, 5
	la $a3, start_msg_11
	jal draw_string

	
	li $a0, 5
	li $a1, 32
	li $a2, 11
	la $a3, start_msg_2
	jal draw_string


	li $a0, 5
	li $a1, 38
	li $a2, 12
	la $a3, start_msg_22
	jal draw_string

	li $a0, 5
	li $a1, 46
	li $a2, 12
	la $a3, start_msg_3
	jal draw_string


	li $a0, 5
	li $a1, 52
	li $a2, 12
	la $a3, start_msg_33
	jal draw_string

	

	lw $t0, keyDown
	beq $t0, 113, game_init

	jal update_screen
	# Sleep
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall

	j start_screen_loop







death_screen:
	la $s7, buffer
	li $s1, 0 # Camera x
	li $s2, 20
	li $s3, 0 # level
	li $s4, 1
	li $s6, SFX_DELAY

	jal init_all_obs

	jal init_numbers

	jal init_letters

	jal draw_bkg

	jal init_car_arr

	lw $t0, i_p_loc_x
	sw $t0, p_loc_x

	lw $t0, i_p_loc_y
	sw $t0, p_loc_y

	lw $t0, f_zero
	sw $t0, p_vel_x
	sw $t0, p_vel_y

	li $t0, 52
	sw $t0, p_int_loc_x

	li $t0, 32
	sw $t0, p_int_loc_y

	li $t0, 3
	sw $t0, p_lives

	li $s0, 1 # time

death_screen_loop:
	jal capture_key

	li $a0, 5
	li $a1, 5
	li $a2, 11
	la $a3, death_msg_0
	jal draw_string
	
	li $a0, 5
	li $a1, 32
	li $a2, 11
	la $a3, start_msg_2
	jal draw_string


	li $a0, 5
	li $a1, 38
	li $a2, 12
	la $a3, start_msg_22
	jal draw_string

	li $a0, 5
	li $a1, 46
	li $a2, 12
	la $a3, start_msg_3
	jal draw_string

	li $a0, 5
	li $a1, 52
	li $a2, 12
	la $a3, start_msg_33
	jal draw_string

	lw $t0, keyDown
	beq $t0, 114, game_init

	lw $t0, keyDown
	beq $t0, 101, start_screen

	jal update_screen
	# Sleep
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall

	j death_screen_loop




.globl game_init

game_init:
	la $s7, buffer
	li $s1, 0 # Camera x
	li $s2, 20
	li $s3, 0 # level
	li $s4, 1
	li $s6, SFX_DELAY

	jal init_all_obs

	jal init_numbers

	jal init_letters

	jal draw_bkg

	jal init_car_arr

	lw $t0, i_p_loc_x
	sw $t0, p_loc_x

	lw $t0, i_p_loc_y
	sw $t0, p_loc_y

	lw $t0, f_zero
	sw $t0, p_vel_x
	sw $t0, p_vel_y

	li $t0, 52
	sw $t0, p_int_loc_x

	li $t0, 32
	sw $t0, p_int_loc_y

	li $t0, 3
	sw $t0, p_lives

	li $s0, 1 # time
	j game_loop

game_loop:
	jal capture_key

	lw $t0, keyDown
	beq $t0, 114, game_init

	lw $t0, keyDown
	beq $t0, 101, start_screen

	# Erase
	lw $a0, p_int_loc_x
	lw $a1, p_int_loc_y
	sub $a0, $a0, $s1
	jal erase_player_car

	jal erase_time
	jal erase_obs
	jal erase_dividers_white
	jal erase_dividers_yellow
	jal erase_lives
	jal erase_level
	
	# Game logic
	jal check_death

	jal set_speed
	add $s0, $s0, $s4

	jal player_move_ws
	jal player_move_ad

	jal process_player_vel

	jal process_player_score

	jal move_obs_all

	jal update_level

	jal update_camera

	jal spawn_cars

	jal erase_hearts

	jal erase_invinces

	# Draw
	jal draw_dividers_white
	jal draw_dividers_yellow
	
	jal draw_obs

	lw $a0, p_int_loc_x
	lw $a1, p_int_loc_y
	sub $a0, $a0, $s1
	jal draw_player_car

	jal handle_obs_collision

	jal draw_time

	jal draw_lives

	jal draw_level

	jal update_screen_handle_sfx

	# Sleep
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall

	# addi $s4, $s4, 1
	j game_loop
	
.globl capture_key

capture_key:
	li $t0, key_is_down
	lw $t1, ($t0)
	beq $t1, 0, no_key_pressed

	lw $t1, 4($t0)

	sw $t1, keyDown
	j capture_key_return

no_key_pressed:
	li $t0, 0
	sw $t0, keyDown

capture_key_return:
	jr $ra


.globl process_player_vel

process_player_vel:
	lw $t0, p_vel_x
	lw $t1, p_vel_y
	lw $t2, p_loc_x
	lw $t3, p_loc_y

	mtc1 $t0, $f0
	mtc1 $t1, $f2
	mtc1 $t2, $f4
	mtc1 $t3, $f6

	add.s $f4, $f4, $f0
	add.s $f6, $f6, $f2

	mfc1 $t2, $f4
	mfc1 $t3, $f6

	sw $t2, p_loc_x
	sw $t3, p_loc_y

	cvt.w.s $f0, $f4
	cvt.w.s $f2, $f6

	mfc1 $t0, $f0
	mfc1 $t1, $f2

	sw $t0, p_int_loc_x
	sw $t1, p_int_loc_y

	blt $t0, $zero, process_player_vel_clamp_x_min
	bgt $t0, MAX_X, process_player_vel_clamp_x_max
	j no_process_player_vel_clamp_x

process_player_vel_clamp_x_max:
	li $t0, MAX_X
	sw $t0, p_int_loc_x
	
	lw $t0, f_max_x
	sw $t0, p_loc_x


	lw $t0, f_bounce_x_left
	sw $t0, p_vel_x

	li $s5, SFX_DELAY
	li $t0, 0
	sw $t0, g_effect

	lw $t2, p_lives
	addi $t2, $t2, -1
	sw $t2, p_lives
	
	li $t0, 1
	sw $t0, p_should_reset

	j no_process_player_vel_clamp_x

process_player_vel_clamp_x_min:
	li $t0, 0
	sw $t0, p_int_loc_x
	
	lw $t0, f_zero
	sw $t0, p_loc_x
	
	lw $t0, f_bounce_x_right
	sw $t0, p_vel_x

	li $s5, SFX_DELAY
	li $t0, 0
	sw $t0, g_effect

	lw $t2, p_lives
	addi $t2, $t2, -1
	sw $t2, p_lives
	
	li $t0, 1
	sw $t0, p_should_reset
	j no_process_player_vel_clamp_x

no_process_player_vel_clamp_x:


	blt $t1, $zero, process_player_vel_clamp_y_min
	bgt $t1, MAX_Y, process_player_vel_clamp_y_max
	j no_process_player_vel_clamp_y

process_player_vel_clamp_y_max:
	li $t0, MAX_Y
	sw $t0, p_int_loc_y
	
	lw $t0, f_max_y
	sw $t0, p_loc_y
	j no_process_player_vel_clamp_y

process_player_vel_clamp_y_min:
	li $t0, 0
	sw $t0, p_int_loc_y
	
	lw $t0, f_zero
	sw $t0, p_loc_y
	j no_process_player_vel_clamp_y

no_process_player_vel_clamp_y:

	# divide vel_x
	lw $t0, p_vel_x
	lw $t1, f_decc
	mtc1 $t0, $f0
	mtc1 $t1, $f2
	div.s $f0, $f0, $f2
	mfc1 $t0, $f0
	sw $t0, p_vel_x

	# divide vel_y
	lw $t0, p_vel_y
	lw $t1, f_decc
	mtc1 $t0, $f0
	mtc1 $t1, $f2
	div.s $f0, $f0, $f2
	mfc1 $t0, $f0
	sw $t0, p_vel_y

	jr $ra



.globl player_move_ws

player_move_ws:
	lw $t0, keyDown
	beq $t0, 115, player_move_s
	beq $t0, 119, player_move_w
	j player_no_move_ws

player_move_w:
	lw $t1, f_acc_bwd
	sw $t1, p_vel_y

	j player_no_move_ws

player_move_s:
	lw $t1, f_acc_fwd
	sw $t1, p_vel_y

	j player_no_move_ws

player_no_move_ws:
	jr $ra




.globl player_move_ad

player_move_ad:
	lw $t0, keyDown
	beq $t0, 97, player_move_a
	beq $t0, 100, player_move_d
	j player_no_move_ad

player_move_a:


	lw $t0, f_x_acc_bwd
	lw $t1, p_vel_x

	mtc1 $t0, $f0
	mtc1 $t1, $f2
	add.s $f0, $f0, $f2
	mfc1 $t0, $f0
	sw $t0, p_vel_x

	j player_no_move_ad

player_move_d:

	lw $t0, f_x_acc_fwd
	lw $t1, p_vel_x

	mtc1 $t0, $f0
	mtc1 $t1, $f2
	add.s $f0, $f0, $f2
	mfc1 $t0, $f0
	sw $t0, p_vel_x

	j player_no_move_ad

player_no_move_ad:
	jr $ra



.globl draw_dividers_white

draw_dividers_white:
	move $t7, $ra

	li $t0, WHITE_LINE_INTERVAL
	div $s0, $t0
	mfhi $a1
	subi $a1, $a1, WHITE_LINE_INTERVAL
	
	li $a0, 12
	sub $a0, $a0, $s1

	jal draw_divider_white

	addi $a0, $a0, 12
	jal draw_divider_white

	addi $a0, $a0, 12
	jal draw_divider_white

	addi $a0, $a0, 26
	jal draw_divider_white

	addi $a0, $a0, 12
	jal draw_divider_white

	addi $a0, $a0, 12
	jal draw_divider_white

	jr $t7

.globl erase_dividers_white

erase_dividers_white:
	move $t7, $ra

	li $t0, WHITE_LINE_INTERVAL
	div $s0, $t0
	mfhi $a1
	subi $a1, $a1, WHITE_LINE_INTERVAL

	li $a0, 12
	sub $a0, $a0, $s1

	jal erase_divider_white

	addi $a0, $a0, 12
	jal erase_divider_white

	addi $a0, $a0, 12
	jal erase_divider_white

	addi $a0, $a0, 26
	jal erase_divider_white

	addi $a0, $a0, 12
	jal erase_divider_white

	addi $a0, $a0, 12
	jal erase_divider_white

	jr $t7

draw_dividers_yellow:
	move $t7, $ra

	li $a0, 48
	sub $a0, $a0, $s1

	li $a1, 0

	jal draw_divider_yellow
	jr $t7

erase_dividers_yellow:
	move $t7, $ra

	li $a0, 48
	sub $a0, $a0, $s1

	li $a1, 0

	jal erase_divider_yellow
	jr $t7

update_camera:
	lw $t0, p_int_loc_x
	subi $t0, $t0, 32
	move $s1, $t0

	bge $s1, $zero, no_set_zero
	move $s1, $zero

no_set_zero:

	ble $s1, CAMERA_MAX_X, no_set_max
	li $s1, CAMERA_MAX_X
no_set_max:

	jr $ra





draw_obs:
	move $t8, $ra

	la $t5, obs_arr
	addi $t6, $t5, OBS_ARR_SIZE

draw_obs_loop:
	lw $t0, 24($t5)
	beq $t0, $zero, draw_obs_loop_no_draw

	lw $a0, 28($t5)
	lw $a1, 32($t5)
	lw $t2, 8($t5)
	sub $a0, $a0, $s1

	jal draw_obs_loop_get_ra
draw_obs_loop_get_ra:
	addi $ra, $ra, 8
	jr $t2

draw_obs_loop_no_draw:
	addi $t5, $t5, SIZE_OBS

	blt $t5, $t6, draw_obs_loop

	jr $t8





erase_obs:
	move $t8, $ra

	la $t5, obs_arr
	addi $t6, $t5, OBS_ARR_SIZE

erase_obs_loop:
	lw $t0, 24($t5)
	beq $t0, $zero, erase_obs_loop_no_draw

	lw $a0, 28($t5)
	lw $a1, 32($t5)
	lw $t2, 12($t5)

	sub $a0, $a0, $s1

	jal erase_obs_loop_get_ra
erase_obs_loop_get_ra:
	addi $ra, $ra, 8
	jr $t2

erase_obs_loop_no_draw:
	addi $t5, $t5, SIZE_OBS

	blt $t5, $t6, erase_obs_loop

	jr $t8




move_obs_all:
	move $t7, $ra
	li $t8, 0

move_obs_all_loop:
	move $a0, $t8
	jal move_obs
	addi $t8, $t8, 1
	blt $t8, NUM_OBS, move_obs_all_loop

	jr $t7




spawn_cars:
	addi $s2, $s2, -1

	bgt $s2, $zero, spawn_cars_no_spawn

	la $t0, obs_arr
	addi $t1, $t0, OBS_ARR_SIZE

spawn_cars_search_loop:
	lw $t2, 24($t0)

	beq $t2, $zero, spawn_cars_break_search_loop

	addi $t0, $t0, SIZE_OBS

	bne $t0, $t1, spawn_cars_search_loop

	j spawn_cars_no_spawn

spawn_cars_break_search_loop:
	lw $t1, g_level
	beq $t1, 1, spawn_cars_level_0

	li $t1, 15
	mult $t1, $s0
	mflo $t1
	li $t3, 8
	div $t1, $t3
	mfhi $t1
	j spawn_cars_level_skip
	# t1 = time * 1153 mod 8

spawn_cars_level_0:
	li $a1, 8
	li $v0, 42
	syscall
	move $t1, $a0
	
spawn_cars_level_skip:

	li $t4, 443
	mult $t4, $s0
	mflo $t4
	li $t3, 23
	div $t4, $t3
	mfhi $t4


	beq $t4, $zero, spawn_cars_spawn_heart
	beq $t4, 1, spawn_cars_spawn_invince
	beq $t4, 2, spawn_cars_spawn_right_arrow
	beq $t4, 3, spawn_cars_spawn_left_arrow
	beq $t4, 4, spawn_cars_spawn_up_arrow
	beq $t4, 5, spawn_cars_spawn_down_arrow
	


	li $t3, 1235
	mult $t3, $t4
	mflo $t4
	li $t3, MAX_OBST_CAR_SPEED
	div $t4, $t3
	mfhi $t5

	addi $t6, $t5, 1

	la $t4, erase_obst_car
	sw $t4, 12($t0)

	li $t4, 12
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	ble $t1, 50, spawn_cars_no_jump_lane

	la $t3, car_draw_arr
	sll $t4, $t5, 2

	add $t4, $t4, $t3
	
	# la $t4, draw_obst_car_fwd_0
	lw $t4, ($t4)
	sw $t4, 8($t0)

	addi $t1, $t1, 2

	sw $t1, 28($t0)

	li $t4, 64
	sw $t4, 32($t0)
	li $t2, 1
	sw $t2, 24($t0)

	# vel
	sub $t4, $zero, $t6
	sw $t4, 20($t0)

	li $t0, 3000
	li $t1, MIN_COOLDOWN
	sub $t0, $t0, $s0
	ble $t0, $t1, spawn_cars_no_jump_lane_invert_cooldown_0
	li $t2, 100
	div $t0, $t2
	mflo $t0
	move $s2, $t0
	j spawn_cars_no_spawn

spawn_cars_no_jump_lane_invert_cooldown_0:
	li $t0, MIN_COOLDOWN

	li $s2, 7
	jr $ra

spawn_cars_no_jump_lane:
	la $t3, car_draw_arr
	sll $t4, $t5, 2
	add $t4, $t4, $t3
	addi $t4, $t4, HALF_CAR_ARR_SIZE

	# la $t4, draw_obst_car_bwd_0
	lw $t4, ($t4)
	sw $t4, 8($t0)

	# init car
	sw $t1, 28($t0)

	li $t4, -12
	sw $t4, 32($t0)
	li $t2, 1
	sw $t2, 24($t0)

	# vel
	sw $t6, 20($t0)

	li $t0, 3000
	li $t1, MIN_COOLDOWN
	sub $t0, $t0, $s0
	ble $t0, $t1, spawn_cars_no_jump_lane_invert_cooldown_1
	li $t2, 40
	div $t0, $t2
	mflo $t0
	move $s2, $t0
	j spawn_cars_no_spawn

spawn_cars_no_jump_lane_invert_cooldown_1:
	li $t0, MIN_COOLDOWN

	li $s2, 7
	
	jr $ra

spawn_cars_spawn_heart:
	la $t1, draw_heal_heart
	sw $t1, 8($t0)
	la $t1, erase_heart
	sw $t1, 12($t0)

	li $t1, 981
	mult $t1, $s0
	mflo $t1
	li $t3, 8
	div $t1, $t3
	mfhi $t1

	li $t4, 8
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	li $t4, 1
	sw $t4, 20($t0)
	li $t4, -6
	sw $t4, 32($t0)
	sw $t1, 28($t0)
	li $t1, 1
	sw $t1, 24($t0)

	jr $ra

spawn_cars_spawn_invince:
	la $t1, draw_invince
	sw $t1, 8($t0)
	la $t1, erase_invince
	sw $t1, 12($t0)

	li $t1, 157
	mult $t1, $s0
	mflo $t1
	li $t3, 9
	div $t1, $t3
	mfhi $t1

	li $t4, 8
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	li $t4, 1
	sw $t4, 20($t0)
	li $t4, -6
	sw $t4, 32($t0)
	sw $t1, 28($t0)
	li $t1, 1
	sw $t1, 24($t0)

	jr $ra

spawn_cars_spawn_right_arrow:
	la $t1, draw_right_arrow
	sw $t1, 8($t0)
	la $t1, erase_arrow
	sw $t1, 12($t0)

	li $t1, 427
	mult $t1, $s0
	mflo $t1
	li $t3, 9
	div $t1, $t3
	mfhi $t1

	li $t4, 8
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	li $t4, 1
	sw $t4, 20($t0)
	li $t4, -6
	sw $t4, 32($t0)
	sw $t1, 28($t0)
	li $t1, 1
	sw $t1, 24($t0)

	jr $ra

spawn_cars_spawn_up_arrow:
	la $t1, draw_up_arrow
	sw $t1, 8($t0)
	la $t1, erase_arrow
	sw $t1, 12($t0)

	li $t1, 345
	mult $t1, $s0
	mflo $t1
	li $t3, 9
	div $t1, $t3
	mfhi $t1

	li $t4, 8
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	li $t4, 1
	sw $t4, 20($t0)
	li $t4, -6
	sw $t4, 32($t0)
	sw $t1, 28($t0)
	li $t1, 1
	sw $t1, 24($t0)

	jr $ra

spawn_cars_spawn_left_arrow:
	la $t1, draw_left_arrow
	sw $t1, 8($t0)
	la $t1, erase_arrow
	sw $t1, 12($t0)

	li $t1, 987
	mult $t1, $s0
	mflo $t1
	li $t3, 9
	div $t1, $t3
	mfhi $t1

	li $t4, 8
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	li $t4, 1
	sw $t4, 20($t0)
	li $t4, -6
	sw $t4, 32($t0)
	sw $t1, 28($t0)
	li $t1, 1
	sw $t1, 24($t0)

	jr $ra

spawn_cars_spawn_down_arrow:
	la $t1, draw_down_arrow
	sw $t1, 8($t0)
	la $t1, erase_arrow
	sw $t1, 12($t0)

	li $t1, 763
	mult $t1, $s0
	mflo $t1
	li $t3, 9
	div $t1, $t3
	mfhi $t1

	li $t4, 8
	mult $t1, $t4
	mflo $t1
	addi $t1, $t1, 4

	li $t4, 1
	sw $t4, 20($t0)
	li $t4, -6
	sw $t4, 32($t0)
	sw $t1, 28($t0)
	li $t1, 1
	sw $t1, 24($t0)

	jr $ra

spawn_cars_no_spawn:
	jr $ra



handle_obs_collision:
	bgt $s5, $zero, handle_obs_collision_no_collide

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


	lw $t1, 4($t0)
	beq $t1, bkg, handle_obs_collision_no_collide_0
	beq $t1, cW, handle_obs_collision_no_collide_0
	beq $t1, cY, handle_obs_collision_no_collide_0
	beq $t1, cHeart, handle_obs_collision_heart
	beq $t1, cInvince, handle_obs_collision_invince
	beq $t1, cRight, handle_obs_collision_right
	beq $t1, cLeft, handle_obs_collision_left
	beq $t1, cUp, handle_obs_collision_up
	beq $t1, cDown, handle_obs_collision_down

	j handle_obs_collision_car

handle_obs_collision_no_collide_0:

	lw $t1, 24($t0)
	beq $t1, bkg, handle_obs_collision_no_collide_1
	beq $t1, cW, handle_obs_collision_no_collide_1
	beq $t1, cY, handle_obs_collision_no_collide_1
	beq $t1, cHeart, handle_obs_collision_heart
	beq $t1, cInvince, handle_obs_collision_invince
	beq $t1, cRight, handle_obs_collision_right
	beq $t1, cLeft, handle_obs_collision_left
	beq $t1, cUp, handle_obs_collision_up
	beq $t1, cDown, handle_obs_collision_down

	j handle_obs_collision_car

handle_obs_collision_no_collide_1:

	addi $t0, $t0, 2816 # 256 * 11

	lw $t1, 4($t0)
	beq $t1, bkg, handle_obs_collision_no_collide_2
	beq $t1, cW, handle_obs_collision_no_collide_2
	beq $t1, cY, handle_obs_collision_no_collide_2
	beq $t1, cHeart, handle_obs_collision_heart
	beq $t1, cInvince, handle_obs_collision_invince
	beq $t1, cRight, handle_obs_collision_right
	beq $t1, cLeft, handle_obs_collision_left
	beq $t1, cUp, handle_obs_collision_up
	beq $t1, cDown, handle_obs_collision_down

	j handle_obs_collision_car

handle_obs_collision_no_collide_2:

	lw $t1, 24($t0)
	beq $t1, bkg, handle_obs_collision_no_collide
	beq $t1, cW, handle_obs_collision_no_collide
	beq $t1, cY, handle_obs_collision_no_collide
	beq $t1, cHeart, handle_obs_collision_heart
	beq $t1, cInvince, handle_obs_collision_invince
	beq $t1, cRight, handle_obs_collision_right
	beq $t1, cLeft, handle_obs_collision_left
	beq $t1, cUp, handle_obs_collision_up
	beq $t1, cDown, handle_obs_collision_down

	j handle_obs_collision_car

handle_obs_collision_car:
	bgt $s5, $zero, handle_obs_collision_no_collide

	li $s5, SFX_DELAY
	li $t0, 0
	sw $t0, g_effect

	lw $t1, p_lives
	addi $t1, $t1, -1
	sw $t1, p_lives
	
	li $t0, 1
	sw $t0, p_should_reset
	
	lw $t0, f_mid_x
	lw $t1, f_mid_y
	lw $t2, p_loc_x
	lw $t3, p_loc_y
	lw $t4, f_dampening

	mtc1 $t0, $f0
	mtc1 $t1, $f2
	mtc1 $t2, $f4
	mtc1 $t3, $f6
	mtc1 $t4, $f8

	sub.s $f0, $f0, $f4
	sub.s $f2, $f2, $f6

	div.s $f0, $f0, $f8
	div.s $f2, $f2, $f8

	mfc1 $t0, $f0
	mfc1 $t1, $f2

	sw $t0, p_vel_x
	sw $t1, p_vel_y

	j handle_obs_collision_no_collide

handle_obs_collision_heart:

	lw $t1, p_lives
	addi $t1, $t1, 1
	sw $t1, p_lives

	li $t1, 1
	sw $t1, g_erase_hearts

	j handle_obs_collision_no_collide

handle_obs_collision_invince:

	li $t1, 1
	sw $t1, g_erase_invince

	li $s5, INVINCE_TIME
	li $t1, 2
	sw $t1, g_effect

	j handle_obs_collision_no_collide

handle_obs_collision_right:
	lw $t0, f_arrow_bounce_pos
	sw $t0, p_vel_x

	j handle_obs_collision_no_collide

handle_obs_collision_left:
	lw $t0, f_arrow_bounce_neg
	sw $t0, p_vel_x

	j handle_obs_collision_no_collide

handle_obs_collision_up:
	lw $t0, f_arrow_bounce_neg
	sw $t0, p_vel_y

	j handle_obs_collision_no_collide

handle_obs_collision_down:
	lw $t0, f_arrow_bounce_pos
	sw $t0, p_vel_y

	j handle_obs_collision_no_collide

handle_obs_collision_no_collide:

	jr $ra




set_speed:
	lw $t0, p_int_loc_y
	li $t1, 64
	sub $t0, $t1, $t0
	li $t1, 8

	div $t0, $t1
	mflo $t0
	subi $t0, $t0, 3

	ble $t0, 0, set_speed_clamp

	move $s4, $t0
	jr $ra

set_speed_clamp:
	li $t0, 1
	move $s4, $t0

	jr $ra



update_screen_handle_sfx:
	move $t7, $ra

	ble $s5, $zero, update_screen_handle_sfx_normal
	lw $t0, g_effect
	addi $s5, $s5, -1
	
	beq $t0, 1, update_screen_handle_sfx_invince
	beq $t0, 2, update_screen_handle_sfx_invince_manual

	lw $t0, g_flip

	beq $t0, 0, update_screen_handle_sfx_flip

	li $t0, 0
	sw $t0, g_flip

	jal update_screen_red
	jr $t7

update_screen_handle_sfx_flip:
	li $t0, 1
	sw $t0, g_flip

update_screen_handle_sfx_normal:
	jal update_screen

	jr $t7

update_screen_handle_sfx_invince:
	jal update_screen_red
	jr $t7

update_screen_handle_sfx_invince_manual:
	jal update_screen_blue
	jr $t7


draw_time:
	# 7 digits
	move $t8, $ra

	move $t5, $s0

	li $t6, 10

	li $a0, 60
	li $a1, 58

	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number
	
	li $a0, 56
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number

	li $a0, 52
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number

	li $a0, 48
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number

	li $a0, 44
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number
	
	li $a0, 40
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number

	li $a0, 36
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number

	li $a0, 32
	div $t5, $t6
	mfhi $a2
	mflo $t5
	jal draw_number


	jr $t8

erase_time:
	move $t8, $ra

	li $a0, 60
	li $a1, 58
	jal erase_number

	li $a0, 56
	jal erase_number

	li $a0, 52
	jal erase_number

	li $a0, 48
	jal erase_number

	li $a0, 44
	jal erase_number

	li $a0, 40
	jal erase_number

	li $a0, 36
	jal erase_number

	li $a0, 32
	jal erase_number

	jr $t8



draw_lives:
	move $t7, $ra

	li $a1, 9
	li $a0, 2
	li $t5, 0
	lw $t6, p_lives
	li $t8, 10

draw_lives_loop:
	bge $t5, $t6, draw_lives_loop_exit
	bgt $t5, $t8, draw_lives_loop_exit
	jal draw_heart
	addi $a0, $a0, 6
	addi $t5, $t5, 1
	j draw_lives_loop
	

draw_lives_loop_exit:
	jr $t7

erase_lives:
	move $t7, $ra

	li $a1, 9
	li $a0, 2
	li $t5, 0
	lw $t6, p_lives
	li $t8, 10

erase_lives_loop:
	bge $t5, $t6, erase_lives_loop_exit
	bgt $t5, $t8, draw_lives_loop_exit
	jal erase_heart
	addi $a0, $a0, 6
	addi $t5, $t5, 1
	j erase_lives_loop

erase_lives_loop_exit:
	jr $t7

process_player_score:
	lw $t0, p_should_reset

	beq $t0, $zero, process_player_score_no_reset

	li $s0, 0
	sw $s0, p_should_reset

process_player_score_no_reset:
	jr $ra





update_level:
	ble $s0, 3000, update_level_level_1
	li $t0, 2
	sw $t0, g_level
	jr $ra

update_level_level_1:
	li $t0, 1
	sw $t0, g_level

update_level_exit:
	jr $ra



draw_level:
	move $t8, $ra

	li $a1, 2

	li $a0, 2
	li $a2, 11
	jal draw_letter

	li $a0, 6
	li $a2, 4
	jal draw_letter

	li $a0, 10
	li $a2, 21
	jal draw_letter

	li $a0, 14
	li $a2, 4
	jal draw_letter

	li $a0, 18
	li $a2, 11
	jal draw_letter

	li $a0, 24
	lw $a2, g_level
	jal draw_number

	jr $t8

erase_level:
	move $t8, $ra

	li $a0, 2
	li $a1, 2
	jal erase_number

	li $a0, 6
	jal erase_number

	li $a0, 10
	jal erase_number

	li $a0, 14
	jal erase_number

	li $a0, 18
	jal erase_number

	li $a0, 24
	jal erase_number

	jr $t8

erase_hearts:
	lw $t0, g_erase_hearts
	beq $t0, $zero, erase_hearts_no_erase_heart
	li $t0, 0
	sw $t0, g_erase_hearts

	la $t0, obs_arr
	addi $t1, $t0, OBS_ARR_SIZE
	la $t3, draw_heal_heart

erase_hearts_heart_loop:
	lw $t2, 8($t0)
	bne $t2, $t3, erase_hearts_not_heart
	li $t2, 0
	sw $t2, 24($t0)

erase_hearts_not_heart:

	addi $t0, $t0, SIZE_OBS
	bne $t0, $t1, erase_hearts_heart_loop

erase_hearts_no_erase_heart:
	jr $ra


erase_invinces:
	lw $t0, g_erase_invince
	beq $t0, $zero, erase_invince_no_erase_invince
	li $t0, 0
	sw $t0, g_erase_invince

	la $t0, obs_arr
	addi $t1, $t0, OBS_ARR_SIZE
	la $t3, draw_invince

erase_invince_loop:
	lw $t2, 8($t0)
	bne $t2, $t3, erase_invince_not_invince
	li $t2, 0
	sw $t2, 24($t0)

erase_invince_not_invince:

	addi $t0, $t0, SIZE_OBS
	bne $t0, $t1, erase_invince_loop

erase_invince_no_erase_invince:
	jr $ra

erase_arrows:
	lw $t0, g_erase_arrows
	beq $t0, $zero, erase_arrows_no_erase_arrow
	li $t0, 0
	sw $t0, g_erase_arrows

	la $t0, obs_arr
	addi $t1, $t0, OBS_ARR_SIZE
	la $t3, erase_arrow

erase_arrow_loop:
	lw $t2, 12($t0)
	bne $t2, $t3, erase_arrow_not_arrow
	li $t2, 0
	sw $t2, 24($t0)

erase_arrow_not_arrow:

	addi $t0, $t0, SIZE_OBS
	bne $t0, $t1, erase_arrow_loop

erase_arrows_no_erase_arrow:
	jr $ra



check_death:
	lw $t0, p_lives
	bgt $t0, $zero, check_death_no_death

	addi $s6, $s6, -1
	ble $s6, $zero, check_death_has_death

check_death_no_death:
	jr $ra

check_death_has_death:
	j death_screen
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

end:
