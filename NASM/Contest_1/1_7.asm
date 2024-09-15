%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_UDEC 1, [a]
    GET_UDEC 1, [b]
    GET_UDEC 1, [c]
    GET_UDEC 1, [d]
    xor eax, eax
    movzx ebx, byte [d]
    add eax, ebx
    shl eax, 8
    movzx ebx, byte [c]
    add eax, ebx
    shl eax, 8
    movzx ebx, byte [b]
    add eax, ebx
    shl eax, 8
    movzx ebx, byte [a]
    add eax, ebx
    PRINT_UDEC 4, eax
    xor eax, eax
    ret
    
section .bss
a resb 1
b resb 1
c resb 1
d resb 1