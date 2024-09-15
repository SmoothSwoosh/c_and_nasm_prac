%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    xor eax, eax
    GET_UDEC 4, eax
    GET_UDEC 1, cl
    ROR eax, cl
    PRINT_UDEC 4, eax
    mov eax, 0x0
    ret
