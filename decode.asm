;/*******************************************************************
; * THIS MODULE IMPLEMENTS THE decode(*cadeZip, *matrizCod, *cadeChar)
; * VARIABLES                            
; * ===> *cadeZip at [ebp + 8]                     
; * ===> *matrizCod at [ebp + 12]                      
; * ===> *cadeChar at [ebp + 16]                    
; * ****************************************************************/
%include "asm_io.inc"
segment .bss

segment .text

  extern getLetter, moveLowToHigh
  global decode
 
decode:
  enter 0,0
  pusha

  mov eax, 0
  mov ebx, 0
  mov edi, [ebp + 8]
  mov esi, [ebp + 16]

  mov bl, [edi]         ; bl = cadeZip[0]
  while_loop_1:
    cmp bl, 0 
    je end_while_1

    push dword ebx
    call moveLowToHigh
    add esp, 4

    while_loop_2:
      cmp bh, 0
      je end_while_2

      ; fix this condition 
      shl bh, 1 
      rcl ax, 1

      new_cod:
        push dword edi
        push dword edx
        call getLetter
        add esp, 8
        
        mov byte [esi], al
        inc esi
        mov eax, 0        ; clear the eax
      continue:

      jmp short while_loop_2
    end_while_2:

    inc edi
    mov ebx, 0            ; clear the ebx
    mov bl, [edi]         ; bl = cadeZip[index++]
    jmp short while_loop_1
  end_while_1:

  popa
  mov eax, 0
  leave
  ret