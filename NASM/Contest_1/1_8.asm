%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_HEX 4, [a]
    GET_HEX 4, [b]
    GET_HEX 4, [c]
    xor eax, eax
    xor ebx, ebx
    ;!a * b * !c
    not dword [a]
    not dword [c]
    mov eax, [a]
    and eax, [b]
    and eax, [c]
    
    ;a * b * !c
    not dword [a]
    mov ebx, [a]
    and ebx, [b]
    and ebx, [c]
    
    or eax, ebx
    ;a * !b * c
    not dword [b]
    not dword [c]
    mov ebx, [a]
    and ebx, [b]
    and ebx, [c]
    
    or eax, ebx
    ;a * b * c
    not dword [b]
    mov ebx, [a]
    and ebx, [b]
    and ebx, [c]
    
    or eax, ebx
    PRINT_HEX 4, eax
    xor eax, eax
    ret
    
section .bss
a resd 1
b resd 1
c resd 1
