#!/bin/bash
clear
nasm -f elf32 library.asm
nasm -f elf32 main.asm
gcc -m32 -o test main.c main.o library.o asm_io.o 
./test