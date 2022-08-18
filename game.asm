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