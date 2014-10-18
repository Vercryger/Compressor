%include "asm_io.inc"

; subprogram counter
; Parameters:
;   cadeChar at -> [ebp + 8]
; Note: 
;		res at -> eax
;   eax, ebx, ecx & edx will be destroyed
segment .data
 
segment .text
  global counter
  
  counter:
    push ebp
    mov ebp, esp

		mov edx, 0					; edx will store the number of letters
		mov ebx, [ebp + 8]	; move the "array of bytes" to ebx
		mov ecx, 20					; ecx = cadeChar.length()
		
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
				inc dl
				jmp short end_if
			there_is_an_A:
				rol edx, 8
				inc dl
				ror edx, 8
				jmp short end_if
			there_is_a_B:
				rol edx, 16
				inc dl
				ror edx, 16
				jmp short end_if
			there_is_a_C:
				rol edx, 24
				inc dl
				ror edx, 24
			end_if:
				inc ebx
			loop while_loop
		end_while:

		mov eax, edx			; <- result

    pop ebp
    ret   