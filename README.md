# CSCB58 Final Project - Traffic Racer

To run this project, either open either start.asm or trafficracer.asm

start.asm is the modular version of the project where all the files are split according to their functionality, while trafficracer.asm is the final submission.

## Controls

- W, A, S, D to move
- Q to start the game
- R to restart the game
- E to return to the main menu

## Game mechanics

This game makes use of MIPS' floating point coprocessor to control the position of the player. When the player tries to move, the game sets the player's velocity to
be in that direction. In each game loop, the player's position is summed with the velocity, and the velocity is divided by a constant greater than 1 to
slow down the player while they don't intend to move.

When the player hits the side or a car, the player's velocity is set to the point towards the starting position, calculated by \[Velocity] = (\[Starting position] - \[Player position]) * some constant less than 1.
