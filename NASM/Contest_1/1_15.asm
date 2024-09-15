%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_DEC 4, [point_1]
    GET_DEC 4, [point_1 + 4]
    GET_DEC 4, [point_2 + 8]
    GET_DEC 4, [point_2 + 16]
    GET_DEC 4, [point_3 + 24]
    GET_DEC 4, [point_3 + 32]
    mov eax, [point_2 + 8]
    sub [point_1], eax
    sub [point_3 + 24], eax
    mov eax, [point_2 + 16]
    sub [point_1 + 4], eax
    sub [point_3 + 32], eax
    mov eax, [point_3 + 32]
    imul eax, [point_1]
    mov ebx, [point_1 + 4]
    imul ebx, [point_3 + 24] 
    sub eax, ebx
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx
    cdq
    mov ecx, 2
    idiv ecx
    imul edx, edx, 5
    PRINT_DEC 4, eax
    PRINT_CHAR '.'
    PRINT_DEC 4, edx
    xor eax, eax
    ret
    

section .bss
point_1 resd 2
point_2 resd 2
point_3 resd 2
