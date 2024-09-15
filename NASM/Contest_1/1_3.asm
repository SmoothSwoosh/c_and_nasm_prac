%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_UDEC 4, [a]
    GET_UDEC 4, [b]
    GET_UDEC 4, [c]
    GET_UDEC 4, [d]
    GET_UDEC 4, [e]
    GET_UDEC 4, [f]
    ;(d + e) * c
    mov eax, [c]
    mov ebx, [d]
    add ebx, [e]
    imul eax, ebx
    
    ;(d + f) * b
    mov ecx, [b]
    mov ebx, [d]
    add ebx, [f]
    imul ecx, ebx
    
    add eax, ecx
    ;a * (e + f)
    mov ebx, [a]
    mov ecx, [e]
    add ecx, [f]
    imul ebx, ecx
    
    add eax, ebx
    
    PRINT_UDEC 4, eax
    xor eax, eax
    ret
    
section .bss
a resd 1
b resd 1
c resd 1
d resd 1
e resd 1
f resd 1