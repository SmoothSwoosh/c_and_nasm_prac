%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0

section .text
happy:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x10 ;for A (sum first), B (sum second), C(all) and count of digits
        push ebx
    mov eax, dword [ebp + 0x8]
    mov dword [ebp - 0x4], 0x0 ;A == 0
    mov dword [ebp - 0x8], 0x0 ;B == 0
    mov dword [ebp - 0xC], 0x0 ;C == 0
    mov dword [ebp - 0x10], 0x0 ;count == 0
    .C_loop:
        cmp eax, 0x0
        je .after_C_loop
        inc dword [ebp - 0x10] ;++count
        
        xor edx, edx
        div dword [ebp + 0xC] ;divide on k
        add dword [ebp - 0xC], edx ;C += digit
        
        jmp .C_loop
    .after_C_loop:
        mov eax, dword [ebp - 0x10]
        inc eax ;count + 1
        mov ecx, 0x2
        xor edx, edx
        div ecx ;eax == (count + 1) div 2
        mov dword [ebp - 0x10], eax ;count of digits == (count of digits + 1) div 2
        mov eax, dword [ebp + 0x8]
        mov ebx, 0x0 ;i == 0
        .B_loop:
            cmp ebx, dword [ebp - 0x10]
            je .after_B_loop
            
            xor edx, edx
            div dword [ebp + 0xC]
            add dword [ebp - 0x8], edx ;B += digit
            
            inc ebx ;++i
            jmp .B_loop
        .after_B_loop:
            mov eax, dword [ebp - 0xC]
            sub eax, dword [ebp - 0x8]
            mov dword [ebp - 0x4], eax
            cmp eax, dword [ebp - 0x8]
            
            je .make_ans_one
            mov eax, 0x0
            jmp .epilogue
    .make_ans_one:
        mov eax, 0x1
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x8 ;for n and k
    .input:
        ;n
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
        
        ;k
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8
    mov ebx, dword [ebp - 0x4] ;number == n
    .loop:
        ;check for happy ticket
        push dword [ebp - 0x8]
        push ebx
        call happy
        add esp, 0x8
        
        cmp eax, 0x1
        je .output
        
        inc ebx ;++number
        jmp .loop
    .output:
        push ebx
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret