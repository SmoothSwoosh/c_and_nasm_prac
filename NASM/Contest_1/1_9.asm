%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_DEC 4, eax
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx
    PRINT_UDEC 4, eax
    xor eax, eax
    ret