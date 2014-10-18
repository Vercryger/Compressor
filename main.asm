%include "asm_io.inc"

segment .data

segment .bss

segment .text
	
	extern counter
  global encode
 
encode:
	enter 0,0
	pusha

	push dword [ebp + 8]
	call counter
	add esp, 8

  popa
  mov eax, 0
  leave
  ret

