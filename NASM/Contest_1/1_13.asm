%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_CHAR [letter_1]
    GET_CHAR [number_1]
    GET_CHAR cl; space
    GET_CHAR [letter_2]
    GET_CHAR [number_2]
    mov al, [letter_1]
    sub al, [letter_2]
    mov dl, al
    sar dl, 7
    xor al, dl
    sub al, dl
    mov bl, [number_1]
    sub bl, [number_2]
    mov dl, bl
    sar dl, 7
    xor bl, dl
    sub bl, dl
    add al, bl
    PRINT_DEC 1, al
    xor eax, eax
    ret

section .bss
letter_1 resb 1
number_1 resb 1
letter_2 resb 1
number_2 resb 1