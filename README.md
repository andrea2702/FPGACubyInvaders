# FPGA Cuby Invaders

This project implements a Space Invaders-like game on an FPGA using VHDL, Verilog, and assembly language. The repository contains two folders:
- **FPGA**: Contains all configuration and code files for the FPGA.
- **Assembly**: Contains assembly language code for storing game scores.

## Overview

The game runs on an FPGA board connected to a monitor via VGA. It is controlled using a finite state machine. Verilog is used to read the gyroscope data from the board and move the spaceship accordingly (left or right). VHDL is used for shooting functionality (triggered by a button press) and for displaying the score on the FPGA's displays. LEDs are illuminated when shooting, creating an effect. When the player loses, a red screen is displayed, but pressing a button resets the game, showing a blue start screen. When the player wins, the screen turns green, and the game can be reset. Assembly language is used to store game scores.

## Demo

A video demonstration of the game is available in the repository.
