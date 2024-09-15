%include "io.inc"

section .text
reverse:
;reverse a11
    xor ebx, ebx
    mov ebx, eax
    shr eax, 16
    shl ebx, 16
    or eax, ebx ;
    mov ebx, eax
    and eax, 0xFF00FF00
    shr eax, 8
    and ebx, 0x00FF00FF
    shl ebx, 8
    or eax, ebx ;
    mov ebx, eax
    and eax, 0xF0F0F0F0
    shr eax, 4
    and ebx, 0x0F0F0F0F
    shl ebx, 4
    or eax, ebx ;
    mov ebx, eax
    and eax, 0xCCCCCCCC
    shr eax, 2
    and ebx, 0x33333333
    shl ebx, 2
    or eax, ebx ;
    mov ebx, eax
    and eax, 0xAAAAAAAA
    shr eax, 1
    and ebx, 0x55555555
    shl ebx, 1
    or eax, ebx ;
    retn
next_competition:
    mov eax, [a11]
    and eax, 1
    mov [bita11], eax ;bita11    
    mov eax, [a12]
    and eax, 1 
    mov [bita12], eax ;bita12
    mov eax, [a21]
    and eax, 1 
    mov [bita21], eax ;bita21
    mov eax, [a22]
    and eax, 1 
    mov [bita22], eax ;bita22
    mov eax, [b1]
    and eax, 1 
    mov [bitb1], eax ;bitb1
    mov eax, [b2]
    and eax, 1 
    mov [bitb2], eax ;bitb2
    mov eax, 0
    or eax, [bita11] ;a11
    shl eax, 1
    or eax, [bita12] ;a12
    shl eax, 1
    or eax, [bita21] ;a21
    shl eax, 1
    or eax, [bita22] ;a22
    shl eax, 1
    or eax, [bitb1] ;b1
    shl eax, 1
    or eax, [bitb2] ;b2
    mov dl, byte [arr_x + eax]
    movzx edx, dl ;x
    shl ecx, 1 ;<-1 
    or ecx, edx
    mov dl, byte [arr_y + eax]
    movzx edx, dl ;y
    shl ebx, 1 ;<-1
    or ebx, edx
    ;common ->1
    shr dword [a11], 1
    shr dword [a12], 1
    shr dword [a21], 1
    shr dword [a22], 1
    shr dword [b1], 1
    shr dword [b2], 1
    ret
global CMAIN
CMAIN:
    ;write your code here
    GET_UDEC 4, [a11]
    GET_UDEC 4, [a12]
    GET_UDEC 4, [a21]
    GET_UDEC 4, [a22]
    GET_UDEC 4, [b1]
    GET_UDEC 4, [b2]
    
    mov eax, [a11]
    push eax
    call reverse
    add esp, 4
    mov [a11], eax
    
    mov eax, [a12]
    push eax
    call reverse
    add esp, 4
    mov [a12], eax

    mov eax, [a21]
    push eax
    call reverse
    add esp, 4
    mov [a21], eax
    
    mov eax, [a22]
    push eax
    call reverse
    add esp, 4
    mov [a22], eax
    
    mov eax, [b1]
    push eax
    call reverse
    add esp, 4
    mov [b1], eax
    
    mov eax, [b2]
    push eax
    call reverse
    add esp, 4
    mov [b2], eax
    
    xor ecx, ecx ;x
    xor ebx, ebx ;y
    
    ;for 32 times
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    call next_competition
    
    PRINT_UDEC 4, ecx
    PRINT_CHAR ' '
    PRINT_UDEC 4, ebx
    xor eax, eax
    ret
    

section .bss
a11 resd 1
a12 resd 1
a21 resd 1
a22 resd 1
b1 resd 1
b2 resd 1
bita11 resd 1
bita12 resd 1
bita21 resd 1
bita22 resd 1
bitb1 resd 1
bitb2 resd 1

section .data
arr_x db 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0
arr_y db 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1
