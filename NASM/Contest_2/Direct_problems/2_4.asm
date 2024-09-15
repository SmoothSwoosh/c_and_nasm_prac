%include "io.inc"
extern printf, scanf
section .data
format db '%u', 0

section .text
FUNC:
        push ebp
        mov ebp, esp
        sub esp, 4
    .compare:
        mov eax, [ebp + 8]
        test eax, eax
        jnz .recurse
        xor eax, eax
        jmp .finish
    .recurse:
        mov eax, [ebp + 8]
        xor edx, edx
        mov ecx, 8
        div ecx
        mov [ebp - 4], edx
        push eax
        call FUNC
        add esp, 4
        push dword [ebp - 4]
        push format
        call printf
        add esp, 8
    .finish:
        add esp, 4
        mov esp, ebp
        pop ebp
        ret
global CMAIN
CMAIN:
        mov ebp, esp; for correct debugging
        ;write your code here
        push ebp
        mov ebp, esp
        sub esp, 4
    .vvod:
        lea eax, [ebp - 4]
        push eax
        push format
        call scanf
        add esp, 8
    .if:
        mov eax, dword [ebp - 4]
        test eax, eax
        jnz .rec
        mov eax, 0
        push eax
        push format
        call printf
        add esp, 8
        jmp .finish
    .rec:    
        push dword [ebp - 4]
        call FUNC
        add esp, 4
    .finish:   
        xor eax, eax
        add esp, 4
        mov esp, ebp
        pop ebp
        ret