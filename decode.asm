;/******************************************************************/
; * THIS MODULE IMPLEMENTS THE decode(*cadeZip, *matrizCod, *cadeChar)
; * VARIABLES                            
; * ===> *cadeZip at [ebp + 8]                     
; * ===> *matrizCod at [ebp + 12]                      
; * ===> *cadeChar at [ebp + 16]                    
; * ****************************************************************/
segment .data
  index db 7

segment .text

  extern getLetter
  global decode
 
decode:
  enter 0,0
  pusha

  mov eax, 0
  mov ebx, 0
  mov edi, [ebp + 8]
  mov esi, [ebp + 16]

  mov bh, [edi]                 ; bh = cadeZip[0]
  inc edi
  mov bl, [edi]                 ; bl = cadeZip[1]
  shl bx, 1                     ; deletes the first 0
  
  while_loop:
    
    dec dword [index]
    shl bx, 1
    jnc new_cod                 ; if (carry == 0) then new_cod 
    rcl al, 1

    jmp short continue

    new_cod:
      cmp al, 0
      je end_while

      push dword [ebp + 12]     ; push *matrizCod
      push dword eax
      call getLetter
      add esp, 8
      
      mov byte [esi], al        ; cadeChar[j++] = al
      inc esi                 
      mov eax, 0                ; clear the eax
    continue:

    cmp dword [index], 0                  
    jne end_if 
      inc edi
      mov bl, [edi]             ; bl = cadeZip[i++]
      
      mov dword [index], 8      ; index = 8
    end_if:
    
    jmp short while_loop
  end_while:  

  popa
  mov eax, 0
  leave
  ret