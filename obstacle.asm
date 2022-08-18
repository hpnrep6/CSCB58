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