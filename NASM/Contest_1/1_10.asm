%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    GET_UDEC 4, [n] 
    mov eax, [n]
    GET_UDEC 4, [k]
    mov ebx, [k]
    sub eax, 1
    cdq
    idiv dword[two]
    mov dword [divid], eax
    mov dword [remainder], edx
    imul eax, dword [divid], 83 
    xor ecx, ecx
    imul ecx, dword [remainder], 41
    add eax, ecx
    add eax, ebx
    PRINT_UDEC 4, eax
    xor eax, eax
    ret
    
section .bss
n resd 1
k resd 1
divid resd 1
remainder resd 1

section .data
two dd 2