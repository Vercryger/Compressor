%include "asm_io.inc"

segment .data
	matrix dd 0

segment .bss
	aux resw 1

segment .text
	
	extern counter, sortbyte
  global encode
 
encode:
	enter 0,0
	pusha

	push dword [ebp + 8]	; pointer to cadeChar[]
	call counter
	add esp, 4

	mov [aux], eax				

	push dword eax
	call sortbyte
	add esp, 4

  popa
  mov eax, 0
  leave
  ret

