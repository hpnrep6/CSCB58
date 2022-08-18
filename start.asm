.text
.globl main

main:
	j start_screen
# 	jal draw_bkg

# 	li $a0, 32
# 	li $a1, 32
# 	li $s1, 32

# loop_a:
# 	li $a0, 32
# 	move $a1, $s0
# 	jal capture_key
	
# 	lw $s1, keyDown
# 	li $t0, 119
# 	beq $s1, $t0, w_pressed
# 	j skip_loop
	
# w_pressed:
# 	li $a0, 32
# 	move $a1, $s0
# 	jal erase_player_car
# 	jal erase_divider_white
	
# 	addi $s0, $s0, 1
# 	move $a1, $s0
	
# skip_loop:
# 	jal draw_divider_white
# 	jal draw_player_car
	
	
# 	li $v0, 32
# 	li $a0, 20
# 	syscall
	
# 	j loop_a
	
# 	j end
	
	
.include "utils.asm"
.include "objects.asm"
.include "obstacle.asm"
.include "game.asm"
.include "numbers.asm"
.include "alphabet.asm"

end:
