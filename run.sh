#!/bin/bash
clear
nasm -f elf32 library.asm
nasm -f elf32 encode.asm
nasm -f elf32 decode.asm
gcc -m32 -o test main.c encode.o decode.o library.o asm_io.o 
./test