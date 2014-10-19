%include "asm_io.inc"

segment .data
	matrix db 0

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

	; ecx & ebx will represents the i & j indexes
	mov ecx, 3						; 0 <= ecx < 3
	mov ebx, 3						; 0 <= ebx < 4 

	; edx will be the original register of frequencies
	; eax will be the register of frequencies sorted 

	for_loop_1:
		cmp ebx, 0
		jl end_for_1
		
		mov edx, [aux]			; resets edx
		mov ecx, 3	        ; resets ecx
		for_loop_2:
			
			cmp ecx, 0
			jl end_for_2
				
				cmp al, dl
				je found
				jmp short end_if
			
				found:
					add ecx, matrix		; i need to calculate the matrix dir relative to the letter position (ecx)
					cmp ebx, 3
					je sum_15
					cmp ebx, 2
					je sum_7
					cmp ebx, 1
					je sum_3
					; then sum_0
					mov dword [ecx], 1
					jmp short end_for_2

					sum_15:
						mov dword [ecx], 15
						jmp short end_for_2
					sum_7:
						mov dword [ecx], 7
						jmp short end_for_2
					sum_3:
						mov dword [ecx], 3 
						jmp short end_for_2
				end_if:

			ror edx, 8
			dec ecx
			jmp short for_loop_2
		end_for_2:
		
		ror eax, 8
		dec ebx
		jmp short for_loop_1
	end_for_1:		

	mov ah, [matrix]
	mov al, [matrix + 1]
	rol eax, 16
	mov ah, [matrix + 2]
	mov al, [matrix + 3]
	
	dump_regs 1

	popa
	mov eax, 0
	leave
	ret

