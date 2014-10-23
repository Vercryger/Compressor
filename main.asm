%include "asm_io.inc"
segment .data

	;axval dd 00000001b;

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


; --- BEGIN CODIFICATION ---

; tiene que dejar lo que estaba en BH en el AL hasta donde pueda, si en algun momento se pasa, ah va a ser 1.
	;Entonces sacar lo de al y ponerlo en el arreglo de codificacion(shiftear ax 8 veces), limpiar al para seguir
	; metiendo lo que quedo en bl, cuando bl sea igual a 0, recien ahi pedir la proxima letra.

	mov ecx, 0
	mov ebx, 0
	mov esi, [ebp+8] ;cadena
	mov bl, [esi] ;muevo el primer elemento de la cadena a bl
	mov eax,0 ; en al me va a ir quedando la cadena de bits que voy a tener que meter en el codeZip
	mov ax,00000001b 
	while1: ;while letra != 0
		cmp  bl,0
		je end_while1 

		cmp bl, 65
		je there_is_an_A
		
		cmp bl, 66
		je there_is_a_B
		
		cmp bl, 67
		je there_is_a_C

	;	then there_is_a_D
		mov byte bl, [edi+3] ;edi tiene la matriz y en bl pongo la codificacion  de la letra correspondiente
		push ebx ;meto en la pila la codificacion de la letra
		call rotacion ; la roto para dejarla en bh
		add esp,4
		mov ebx,ecx ;libero ecx, en bh me quedaron los 1's de la codificacion
		jmp short end_if2

		there_is_an_A:
			mov byte bl, [edi] ;edi tiene la matriz y en bl pongo la codificacion  de la letra correspondiente
			push ebx ;meto en la pila la codificacion de la letra
			call rotacion ; la roto para dejarla en bh
			add esp,4
			mov ebx,ecx ;libero ecx, en bh me quedaron los 1's de la codificacion
			jmp short end_if2
		there_is_a_B:
			mov byte bl, [edi+1] ;edi tiene la matriz y en bl pongo la codificacion  de la letra correspondiente
			push ebx ;meto en la pila la codificacion de la letra
			call rotacion ; la roto para dejarla en bh
			add esp,4
			mov ebx,ecx ;libero ecx, en bh me quedaron los 1's de la codificacion
			jmp short end_if2
		there_is_a_C:
			mov byte bl, [edi+2] ;edi tiene la matriz y en bl pongo la codificacion  de la letra correspondiente
			push ebx ;meto en la pila la codificacion de la letra
			call rotacion ; la roto para dejarla en bh
			add esp,4
			mov ebx,ecx ;libero ecx, en bh me quedaron los 1's de la codificacion
			
			end_if2:

			shl ax,1 ; este shifteo se hace siempre para ganar el 0 que tienen todas las codificaciones adelante
			mov ecx,0
			while2:
				cmp ah,1
				je ah_es_1 
				cmp bh,0
				je bh_es_0
				shl bh,1 ;ejecuto esta linea y la siguiente si se cumple ah!=1 && bh != 0
				rcl ah,1
				jmp short while2

				ah_es_1:
				;si ah es 1, es poque ya complete todo el AL y tengo que guardarlo en el arreglo.
				;MOVER EL AL AL ARREGLO EN LA POSICION QUE CORRESPONDA
				shr ax,8
				while3:
					cmp bh,0
					je consumi_lo_restante
					shl bh,1 ;ejecuto esta linea y la siguiente si se cumple ah!=1 && bh != 0
					rcl ah,1
					jmp short while3
				bh_es_0:
					inc esi	
					mov ebx,0	
					mov bl, [esi] ;obtengo la siguiente letra
					jmp while1
				consumi_lo_restante:
					inc esi	
					mov ebx,0	
					mov bl, [esi] ;obtengo la siguiente letra
					jmp while1

				end_while1:

		

		;Esta rutina saca lo que tiene bl y lo pone en bh
		rotacion:
			push ebp
    		mov ebp, esp

    		mov ecx,[ebp+8]
			while:
				cmp cl,0
				je end_while2

				ror cx,1
				jmp short while
			end_while2:

			pop ebp
    		ret 

; --- END CODIFICATION ---

	popa
	mov eax, 0
	leave
	ret

