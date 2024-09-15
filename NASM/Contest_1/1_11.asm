%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_CHAR [letter]
    GET_CHAR [number]
    sub byte [letter], 'A'
    add byte [letter], 1
    sub byte [number], '0'
    mov al, 8
    mov bl, 8
    sub al, byte [letter]
    sub bl, byte [number]
    mul bl 
    shr al, 1
    PRINT_UDEC 1, al
    xor eax, eax
    ret


section .bss
letter resd 1
number resd 1
