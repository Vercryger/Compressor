%include "asm_io.inc"

segment .data
	count_a db 0
	count_b db 0
	count_c db 0
	count_d db 0

segment .bss

segment .text

  global encode
 
encode:
	enter 0,0
	pusha
	mov eax, 0

	mov ebx, [ebp + 8]	; move the "array of bytes" to ebx
	mov ecx, 20
	while_loop:
		cmp ecx, 0
		je end_while
			mov al, [ebx]

			cmp al, 65
			je there_is_an_A
			cmp al, 66
			je there_is_a_B
			cmp al, 67
			je there_is_a_C
		;	then there_is_a_D
			inc dword [count_d]
			jmp short end_if
		there_is_an_A:
			inc dword [count_a]
			jmp short end_if
		there_is_a_B:
			inc dword [count_b]
			jmp short end_if
		there_is_a_C:
			inc dword [count_c]
		end_if:
			inc ebx
		loop while_loop
	end_while:

  popa
  mov eax, 0
  leave
  ret

