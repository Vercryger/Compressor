;/*******************************************************************
; * THIS MODULE IMPLEMENTS THE encode(cadeChar, *matrizCod, *cadeZip)
; * VARIABLES                            
; * ===> cadeChar at [ebp + 8]                     
; * ===> *matrizCod at [ebp + 12]                      
; * ===> *cadeZip at [ebp + 16]                    
; * ****************************************************************/

segment .bss
  aux resw 1

segment .text
  
  extern counter, sortbyte, getCodification
  global encode
 
encode:
  enter 0,0
  pusha

  push dword [ebp + 8]  ; pointer to cadeChar[]
  call counter
  add esp, 4

  mov [aux], eax        

  push dword eax
  call sortbyte
  add esp, 4

;/******************************************************************/
;/*********************** MATRIX CONSTRUCTION **********************/
;/******************************************************************/

  ; esi & edi will represents the i & j indexes
  mov esi, 3            ; 0 <= esi < 4
  mov edi, 3            ; 0 <= edi < 4 

  ; eax will be the register of frequencies sorted 
  ; edx will be the original register of frequencies
  mov ecx, 0

  for_loop_1:
    cmp edi, 0
    jl end_for_1

    mov edx, [aux]      ; resets edx
    mov esi, 3          ; resets esi
    for_loop_2:
      
      cmp esi, 0
      jl end_for_2
        
        cmp al, dl
        je found
        jmp short end_if_1
      
        found:
          add ecx, esi
          ror ecx, 8
        end_if_1:

      ror edx, 8
      dec esi
      jmp short for_loop_2
    end_for_2:

    ror eax, 8
    dec edi
    jmp short for_loop_1
  end_for_1:    

  ; HERE ecx has the positions of each of the letters from the sorted register
  mov edi, [ebp + 12]   ; EDI = pointer to matrizCod[]
  mov edx, 0            ; edx is the offset index
  
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

;/******************************************************************/
;/********************* END MATRIX CONSTRUCTION ********************/
;/******************************************************************/

;/******************************************************************/
;/*********************** BEGIN CODIFICATION ***********************/
;/******************************************************************/

; * VARIABLES                            
; * ===> ESI is the pointer to cadeChar[]                    
; * ===> EDI is the pointer to matrizCod[]               
; * ===> ECX is the pointer to cadeZip[]

; tiene que dejar lo que estaba en BL en el registro AL hasta donde pueda, si en algun momento se pasa, ah va a ser 1.
; Entonces sacar lo de AL y ponerlo en el arreglo de codificacion(shiftear ax 8 veces), limpiar al para seguir
; metiendo lo que quedo en BL, cuando BL sea igual a 0, recien ahi pedir la proxima letra.

  mov eax, 1                ; en AL me va a ir quedando la cadena de bits que voy a tener que meter en el cadeZip
  mov ebx, 0  
  mov ecx, [ebp + 16]       
  mov esi, [ebp + 8]        
  mov bl, [esi]             
  
  while_loop_1:             ; while (letra != 0)
    cmp  bl, 0
    je end_while_1          ; there is no more letters
    
    push dword edi
    push dword ebx
    call getCodification
    add esp, 8

    ; now BL has the letter's codification 
 
    shl ax, 1             ; este shifteo se hace siempre para ganar el 0 que tienen todas las codificaciones adelante
  
    while_loop_2:
      cmp ah, 1
      je ah_es_1 
        cmp bl, 0
        je end_while_2
          shr bl, 1 
          rcl ax, 1
        
          jmp short while_loop_2
      ah_es_1:  
      
      ; if AH == 1 then i have to store the full AL in cadeZip[]
      
      mov byte [ecx], al
      inc ecx

      ; restores AX
      shr ax, 8
      jmp short while_loop_2

    end_while_2:
    
    ; get the next letter from cadeChar[]
    inc esi 
    mov ebx,  0 
    mov bl, [esi]         
    
    jmp while_loop_1
  end_while_1:

;/******************************************************************/
;/************************* END CODIFICATION ***********************/
;/******************************************************************/

  popa
  mov eax, 0
  leave
  ret