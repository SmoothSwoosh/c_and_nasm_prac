%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_DEC 4, [v_x]
    GET_DEC 4, [v_y]
    GET_DEC 4, [a_x]
    GET_DEC 4, [a_y]
    GET_DEC 4, [t]
    mov eax, [t]
    imul eax, eax
    imul eax, [a_x]
    mov ebx, [v_x]
    imul ebx, [t]
    add eax, ebx
    PRINT_DEC 4, eax
    PRINT_CHAR ' '
    
    mov eax, [t]
    imul eax, eax
    imul eax, [a_y]
    mov ebx, [v_y]
    imul ebx, [t]
    add eax, ebx
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret
    
section .bss
v_x resd 1
v_y resd 1
a_x resd 1
a_y resd 1
t resd 1