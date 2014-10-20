segment .data

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

; --- MATRIX CONSTRUCTION ---

	; esi & edi will represents the i & j indexes
	mov esi, 3						; 0 <= esi < 4
	mov edi, 3						; 0 <= edi < 4 

	; edx will be the original register of frequencies
	; eax will be the register of frequencies sorted 
	mov ecx, 0

	for_loop_1:
		cmp edi, 0
		jl end_for_1

		mov edx, [aux]			; resets edx
		mov esi, 3	        ; resets esi
		for_loop_2:
			
			cmp esi, 0
			jl end_for_2
				
				cmp al, dl
				je found
				jmp short end_if
			
				found:
					add ecx, esi
					ror ecx, 8
				end_if:

			ror edx, 8
			dec esi
			jmp short for_loop_2
		end_for_2:

		ror eax, 8
		dec edi
		jmp short for_loop_1
	end_for_1:		

	; ecx has the positions of each of the letters from the sorted register
	mov edi, [ebp + 12]	  ; pointer to matrizCod[]
	mov edx, 0						; edx is the offset index
	
	mov dl, cl
	shr ecx, 8
	mov byte [edi + edx], 15
	
	mov dl, cl
	shr ecx, 8
	mov byte [edi + edx], 7
	
	mov dl, cl
	shr ecx, 8
	mov byte [edi + edx], 3
	
	mov dl, cl
	shr ecx, 8
	mov byte [edi + edx], 1

	
; --- END MATRIX CONSTRUCTION ---
	


	popa
	mov eax, 0
	leave
	ret

