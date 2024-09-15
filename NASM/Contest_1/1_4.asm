%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_DEC 4, [x]
    GET_DEC 4, [n]
    GET_DEC 4, [m]
    GET_DEC 4, [y]
    mov eax, [n]
    sub eax, [m]
    mov ebx, [y]
    sub ebx, 2011
    imul eax, ebx
    mov ebx, [x]
    add ebx, eax
    
    PRINT_DEC 4, ebx
    xor eax, eax
    ret
    

section .bss
x resd 1
n resd 1
m resd 1
y resd 1