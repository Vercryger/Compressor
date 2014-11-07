;/*******************************************************************
; * THIS MODULE IMPLEMENTS THE encode(*cadeChar, *matrizCod, *cadeZip)
; * VARIABLES                            
; * ===> *cadeChar at [ebp + 8]                     
; * ===> *matrizCod at [ebp + 12]                      
; * ===> *cadeZip at [ebp + 16]                    
; * ****************************************************************/
%include "asm_io.inc"
segment .bss
  aux resw 1            ; used for save the original register of frequencies

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
          jmp short end_for_2
        end_if_1:

      ror edx, 8
      dec esi
      jmp short for_loop_2
    end_for_2:

    shr eax, 8
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

  mov eax, 1                ; AL has bits which are inserted in cadeZip
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

    shl ax, 1             ; to insert the 0 that has all codifications
  
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
  
  ; this is a correction
  ; "al" could have bits to store in cadeZip
  while_loop_3:
    cmp ah, 1
    je end_while_3
    shl ax, 1
    
    jmp short while_loop_3
  end_while_3:
  mov byte [ecx], al
  inc ecx

  popa
  mov eax, 0
  leave
  ret