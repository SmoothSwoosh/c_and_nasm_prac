%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0

section .text
greatest_divisor:
    .prologue: 
        push ebp
        mov ebp, esp
        sub esp, 0x4
    mov dword [ebp - 0x4], 0x2 ;i == 2
    .loop:
        .is_squared_i_bigger_than_n:
            mov eax, dword [ebp - 0x4]
            mul eax
            cmp eax, dword [ebp + 0x8]
            jg .choose_answer
        mov eax, dword [ebp + 0x8]
        mov ecx, dword [ebp - 0x4]
        div ecx
        .is_remainder_zero:
            test edx, edx
            jz .choose_answer ;eax == ans
            inc dword [ebp - 0x4]
            jmp .loop
    .choose_answer:
        mov eax, dword [ebp + 0x8]
        mov ecx, dword [ebp - 0x4]
        div ecx
        test edx, edx
        jz .retain
        mov dword [ebp - 0x4], 0x1
        jmp .epilogue
        .retain:
            mov dword [ebp - 0x4], eax
    .epilogue:
        mov eax, dword [ebp - 0x4]
        add esp, 0x4
        mov esp, ebp
        pop ebp
        ret

global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4
    .input_n:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .call_function:
        push dword [ebp - 0x4]
        call greatest_divisor
        add esp, 0x4
    .output:
        push eax
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        add esp, 0x4
        mov esp, ebp
        pop ebp
        ret