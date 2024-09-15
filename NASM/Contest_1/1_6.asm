%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    xor eax, eax
    GET_UDEC 4, eax
    GET_UDEC 1, cl
    mov edx, 0x1
    shl edx, cl
    sub edx, 0x1
    and edx, eax
    PRINT_UDEC 4, edx
    mov eax, 0x0
    ret