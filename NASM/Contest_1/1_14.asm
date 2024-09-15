%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    GET_UDEC 4, [n]
    GET_UDEC 4, [m]
    GET_UDEC 4, [k]
    GET_UDEC 4, [d]
    GET_UDEC 4, [x]
    GET_UDEC 4, [y]
    mov eax, [n]
    imul eax, [m]
    imul eax, [k]
    mov ecx, [d]
    cdq
    idiv ecx 
    
    ;remainder
    sub edx, 1
    mov ebx, 1
    shl ebx, 31
    and edx, ebx
    shr edx, 31
    xor edx, 1
    
    add eax, edx ;eax = number_of_boxes
    mov ebx, [x]
    mov cl, byte [hours + ebx]
    movzx ecx, cl ;ecx = 0 or 1
    mov [good_time], ecx ;good_time = 0 or 1
    mov ecx, 1
    mov [bad_time], ecx
    mov ecx, [good_time]
    xor [bad_time], ecx ;bad_time = 0 or 1
    
    mov ebx, eax ;ebx = number_of_boxes
    ;PRINT_UDEC 4, ebx
    ;NEWLINE
    mov ecx, 3
    cdq
    idiv ecx
    mov cl, byte [remainders + edx]
    movzx ecx, cl
    add eax, ecx
    mov ecx, eax
    mov eax, ebx
    sub eax, ecx ;eax = answer, if its bad time
    
    imul eax, [bad_time]
    imul ebx, [good_time]
    add eax, ebx
    
    PRINT_UDEC 4, eax
    
    xor eax, eax
    ret
    

section .bss
n resd 1
m resd 1
k resd 1
d resd 1
x resd 1
y resd 1
bad_time resd 1
good_time resd 1

section .data
hours db 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
remainders db 0, 1, 1