%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_UDEC 4, eax ;eax = n
    mov ecx, 32
    mov edx, 0
    Oops:
        mov ebx, eax
        and ebx, 1
        add edx, ebx
        shr eax, 1
    LOOP Oops
    PRINT_UDEC 4, edx
    xor eax, eax
    ret
    
    