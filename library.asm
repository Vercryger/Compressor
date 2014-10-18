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
		
		mov al, [ebx]				; al = cadeChar[0]

		while_loop:
			dump_regs 1
			cmp al, 0
			je end_while			; end of cadeChar

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
				mov al, [ebx]			; next element from cadeChar
			loop while_loop
		end_while:

		mov eax, edx			; <- result

    pop ebp
    ret   