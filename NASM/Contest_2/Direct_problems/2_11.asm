%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0

section .text
gcd:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
    .if_b_equals_0:
        mov ebx, dword [ebp + 0xC]
        test ebx, ebx
        jnz .recurse
        mov eax, dword [ebp + 0x8]
        jmp .epilogue
    .recurse:
        mov eax, dword [ebp + 0x8]
        mov ecx, dword [ebp + 0xC]
        xor edx, edx
        div ecx
        push edx ;push remainder of a/b as second parameter
        push dword [ebp + 0xC] ;push b as first parameter
        call gcd
        add esp, 0x8
    .epilogue:
        add esp, 0x0
        mov esp, ebp
        pop ebp
        ret

global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x8
    .input_A:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .input_B:
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8
    .call_function:
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call gcd
        add esp, 0x8
    .output:
        push eax
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        add esp, 0x8
        mov esp, ebp
        pop ebp
        ret