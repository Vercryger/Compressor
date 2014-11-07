%include "asm_io.inc"

; subprogram counter
; Parameters:
;   cadeChar[] at -> [ebp + 8]
; Note: 
;		res at -> eax
;   eax, ebx & edx will be destroyed
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
			cmp al, 0
			je end_while			; end of cadeChar[]

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

; subprogram sortbyte
; Parameters:
;   register to sort at -> [ebp + 8]
; Note: 
;		res at -> eax
;   eax & ecx will be destroyed
segment .data
 
segment .text
	global sortbyte
	
	sortbyte:
		push ebp
		mov ebp, esp

		mov ecx, 0					; ecx will represents the i & j indexes
												; 0 <= ch < 4  &  0 <= cl < 3
		mov eax, [ebp + 8]

		for_loop_1:
			cmp ch, 4
			je end_for_1
			
			mov cl, 0					; resets cl 
			for_loop_2:
				cmp cl, 3
				je end_for_2
				
					cmp ah, al		
					jl swap				; ah < al
					jmp short end_if_sort

					swap:
						xchg ah, al	
					end_if_sort:

				ror eax, 8
				inc cl
				jmp short for_loop_2
			end_for_2:

			ror eax, 8
			inc ch
			jmp short for_loop_1
		end_for_1:		

		pop ebp
		ret   

; subprogram getCodification
; Parameters:
;   ASCII number at -> [ebp + 8]
;		matrizCod[]  at -> [ebp + 12]
; Note: 
;		res at -> ebx
;   ebx will be destroyed
segment .data
 
segment .text
	global getCodification
	
	getCodification:
		push ebp
		mov ebp, esp
		
		mov ebx, [ebp + 8]
		mov edi, [ebp + 12] 

		cmp bl, 65
    je BL_is_an_A
    cmp bl, 66
    je BL_is_a_B
    cmp bl, 67
    je BL_is_a_C

  ; then there_is_a_D
    mov byte bl, [edi + 3] 
    jmp short end_if_2

    BL_is_an_A:
      mov byte bl, [edi] 
      jmp short end_if_2
    BL_is_a_B:
      mov byte bl, [edi + 1] 
      jmp short end_if_2
    BL_is_a_C:
      mov byte bl, [edi + 2] 
      
    end_if_2:

 		pop ebp
		ret 

; subprogram getLetter
; Parameters:
;   codification at -> [ebp + 8]
;		matrizCod[]  at -> [ebp + 12]
; Note: 
;		res at -> eax
;   eax & ecx will be destroyed
segment .data
 
segment .text
	global getLetter
	
	getLetter:
		push ebp
		mov ebp, esp
		
		mov eax, [ebp + 8]
		mov ecx, [ebp + 12] 

		cmp al, [ecx]
    je is_an_A
    cmp al, [ecx + 1]
    je is_a_B
    cmp al, [ecx + 2]
    je is_a_C

  ; then is_a_D
    mov al, 68 
    jmp short end_if_3

    is_an_A:
      mov al, 65
      jmp short end_if_3
    is_a_B:
      mov al, 66 
      jmp short end_if_3
    is_a_C:
      mov al, 67 
      
    end_if_3:

 		pop ebp
		ret 

;***************************
;     THIS IS NOT USED 
;***************************
; subprogram moveLowToHigh
; Parameters:
;   register to move at -> [ebp + 8]
; Note: 
;		res at -> ebx
;   ebx will be destroyed
segment .data
 
segment .text
	global moveLowToHigh
	
	moveLowToHigh:
		push ebp
		mov ebp, esp

		mov ebx, [ebp + 8]
		while_loop_1:
			cmp bl,0
			je end_while_1
			ror bx,1
			jmp short while_loop_1
		end_while_1:

		pop ebp
		ret 