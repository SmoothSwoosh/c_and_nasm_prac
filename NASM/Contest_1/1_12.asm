%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    GET_UDEC 4, [n]
    sub dword [n], 1
    mov eax, [n]
    mov ecx, 13
    cdq
    idiv ecx
    mov bl, byte [arr_lear + eax]
    mov cl, byte [arr_numb + edx]
    PRINT_CHAR cl
    PRINT_CHAR bl
    xor eax, eax
    ret

section .bss
n resd 1
index resd 1

section .data
arr_lear db 'S', 'C', 'D', 'H'
arr_numb db '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'