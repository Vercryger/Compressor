;/*******************************************************************
; * THIS MODULE IMPLEMENTS THE decode(*cadeZip, *matrizCod, *cadeChar)
; * VARIABLES                            
; * ===> *cadeZip at [ebp + 8]                     
; * ===> *matrizCod at [ebp + 12]                      
; * ===> *cadeChar at [ebp + 16]                    
; * ****************************************************************/
segment .data
  index db 0

segment .text

  extern getLetter
  global decode
 
decode:
  enter 0,0
  pusha

  mov eax, 0
  mov ebx, 0
  mov dword [index], 7
  mov edi, [ebp + 8]
  mov esi, [ebp + 16]

  mov bh, [edi]                 ; bh = cadeZip[0]
  inc edi
  mov bl, [edi]                 ; bl = cadeZip[1]
  rol bx, 1                     ; deletes the first 0
  
  while_loop:
    
    dec dword [index]
    shl bx, 1
    jnc new_cod                 ; if (carry == 0) then new_cod 
    rcl al, 1

    jmp short continue

    new_cod:
      push dword [ebp + 12]     ; push *matrizCod
      push dword eax
      call getLetter
      add esp, 8

      mov byte [esi], al
      inc esi
      mov eax, 0                ; clear the eax
    continue:

    cmp bx, 32512               ; bh == 127 && bl == 0
    je end_while

    cmp dword [index], 0                  
    jne end_if 
      inc edi
      mov bl, [edi]             ; bl = cadeZip[index++]

      mov dword [index], 8      ; index = 8

      cmp bl, 0
      jne end_if
        mov bl, 127

    end_if:
    
    jmp short while_loop
  end_while:  
  
  cmp eax, 0
  je end
    push dword [ebp + 12]     ; push *matrizCod
    push dword eax
    call getLetter
    add esp, 8

    mov byte [esi], al
  end:

  popa
  mov eax, 0
  leave
  ret