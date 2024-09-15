%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    mov dword [val1high], 0x0
    mov dword [val2high], 0x0
    mov dword [val3high], 0x0
    GET_UDEC 4, [val1low]
    GET_UDEC 4, [val2low]
    GET_UDEC 4, [val3low]
    GET_UDEC 4, [v]
    
    mov edi, [val1high]
    mov esi, [val1low]
    mov ecx, [val2high]
    mov ebx, [val2low]
    mov eax, edi
    mul ebx
    xchg eax, ebx ; partial product top 32 bits
    mul esi
    xchg esi, eax ; partial product lower 32 bits
    add ebx, edx
    mul ecx
    add ebx, eax ; final upper 32 bits
    ; answer here in EBX:ESI
    mov edi, ebx
    mov ecx, [val3high]
    mov ebx, [val3low]
    mov eax, edi
    mul ebx
    xchg eax, ebx ; partial product top 32 bits
    mul esi
    xchg esi, eax ; partial product lower 32 bits
    add ebx, edx
    mul ecx
    add ebx, eax
    ; answer here in EBX:ESI
    mov edx, ebx
    mov eax, esi
    mov ecx, [v]
    div ecx
    PRINT_UDEC 4, eax
    xor eax, eax
    ret
    
section .bss
val1high resd 1
val1low resd 1
val2high resd 1
val2low resd 1
val3high resd 1
val3low resd 1
v resd 1