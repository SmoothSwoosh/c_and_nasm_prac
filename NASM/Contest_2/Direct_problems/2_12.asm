%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0

section .text
if_k_zero_bits:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x8 ;count and 2^(degree)
    mov dword [ebp - 0x4], 0x0
    mov dword [ebp - 0x8], 0x1 
    mov ebx, 0x0 ;i == 0
    ;search of degree that 2^(degree) <= n
    .loop:
        mov eax, dword [ebp - 0x8]
        cmp eax, dword [ebp + 0x8]
        jg .after_loop
        shl dword [ebp - 0x8], 0x1
        jmp .loop
    .after_loop:
        shr dword [ebp - 0x8], 0x1 
        mov eax, dword [ebp - 0x8]
        test eax, eax
        jz .inc_count_and_check
        .next_loop:
            mov eax, dword [ebp - 0x8]
            test eax, eax
            jz .after_next_loop
            mov ebx, eax
            and ebx, dword [ebp + 0x8]
            cmp ebx, dword [ebp - 0x8]
            jl .inc_count
            shr dword [ebp - 0x8], 0x1
            jmp .next_loop
            .inc_count:
                inc dword [ebp - 0x4]
                shr dword [ebp - 0x8], 0x1
                jmp .next_loop
        .after_next_loop:
            mov eax, dword [ebp - 0x4]
            cmp eax, dword [ebp + 0xC]
            je .make_one
            mov eax, 0x0
            jmp .epilogue
        .inc_count_and_check:
            inc dword [ebp - 0x4]
            mov eax, dword [ebp - 0x4]
            cmp eax, dword [ebp + 0xC]
            je .make_one
            mov eax, 0x0
            jmp .epilogue
            .make_one:
                mov eax, 0x1
                jmp .epilogue
    .epilogue:
        mov esp, ebp
        pop ebp   
        ret    

bicuha:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x8 
    mov dword [ebp - 0x4], 0x0 ;ans
    mov dword [ebp - 0x8], 0x1 ;i
    mov ebx, 0x0
    .preproc_loop:
        cmp ebx, dword [ebp + 0xC]
        jge .loop
        shl dword [ebp - 0x8], 0x1
        inc ebx
        jmp .preproc_loop
    .loop:
        mov ebx, dword [ebp - 0x8]
        cmp ebx, dword [ebp + 0x8]
        jg .after_loop
        push dword [ebp + 0xC]
        push ebx
        call if_k_zero_bits ;eax == 0 or 1
        add esp, 0x8
        test eax, eax
        jnz .increment
        jmp .after_increment
        .increment:
            inc dword [ebp - 0x4]   
        .after_increment:
            inc dword [ebp - 0x8] ;++i
            jmp .loop
    .after_loop:
        mov eax, dword [ebp - 0x4]
    .epilogue:
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
        sub esp, 0x8
    .input_n:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .input_k:
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8
    .call_function:
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call bicuha
        add esp, 0x8
    .output:   
        push eax
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret