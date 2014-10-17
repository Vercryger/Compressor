#!/bin/bash
clear
nasm -f elf main.asm
gcc -o test main.c main.o asm_io.o
./test