#!/bin/bash
clear
nasm -f elf library.asm
nasm -f elf main.asm
gcc -o test main.c main.o library.o asm_io.o 
./test