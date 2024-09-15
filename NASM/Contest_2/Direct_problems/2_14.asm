%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0

section .text
comb:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4
    mov dword [ebp - 0x4], 0x0 ;ans == 0
    .calculate_ans:
        mov ebx, dword [ebp + 0xC]
        cmp ebx, 0x0 ;compare with 0
        je .make_ans_one
        jl .make_ans_zero
        cmp ebx, dword [ebp + 0x8] ;compare with n
        je .make_ans_one
        mov ebx, dword [ebp + 0x8]
        cmp ebx, dword [ebp + 0xC] ;compare n with k
        jl .make_ans_zero
        cmp ebx, 0x0
        jle .make_ans_zero
        
        ;call C(n - 1, k - 1)
        mov ecx, dword [ebp + 0xC]
        dec ecx ;k - 1
        mov ebx, dword [ebp + 0x8]
        dec ebx ;n - 1
        sub esp, 0x4
        push ecx
        push ebx
        call comb
        add esp, 0xC
        
        mul dword [ebp + 0x8]
        xor edx, edx
        div dword [ebp + 0xC]
        
        add dword [ebp - 0x4], eax ;ans += C(n - 1, k - 1)
        
        mov eax, dword [ebp - 0x4] ;eax == ans
        jmp .epilogue
    .make_ans_zero:
        mov eax, 0x0
        jmp .epilogue
    .make_ans_one:
        mov eax, 0x1
        jmp .epilogue
    .epilogue:
        mov esp, ebp
        pop ebp
        ret

number_of_zeros:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x14
    .find_2_power_m:
        mov dword [ebp - 0x4], 0x1 ;2^0
        mov dword [ebp - 0x8], 0x0 ;m == 0
        .loop_2_m:
            mov ebx, dword [ebp - 0x4]
            cmp ebx, dword [ebp + 0x8]
            jg .after_loop_2_m
            mov ebx, dword [ebp - 0x8]
            cmp ebx, 0x1E ;compare with 30
            jge .calculate_part_1
            shl dword [ebp - 0x4], 0x1 ;<< 1
            inc dword [ebp - 0x8] ;++m
            jmp .loop_2_m
        .after_loop_2_m:
            shr dword [ebp - 0x4], 0x1 ;2^m that 2^m <= n < 2^(m + 1)
            dec dword [ebp - 0x8] ;--m
    .calculate_part_1:
        mov dword [ebp - 0xC], 0x0 ;ans
        mov eax, dword [ebp - 0x8]
        sub eax, dword [ebp + 0xC] ;m - k
        cmp eax, 0x0
        jl .make_ans_zero
        
        mov ebx, dword [ebp + 0xC] 
        inc ebx ;k + 1
        
        ;call C(m, k + 1)
        sub esp, 0x4
        push ebx
        push dword [ebp - 0x8]
        call comb
        add esp, 0xC
        mov dword [ebp - 0xC], eax ;ans = part1
    .calculate_part_2:
        mov dword [ebp - 0x14], 0x0 ;number_of_prev_zeros == 0
        shr dword [ebp - 0x4], 0x1 ;2^(m - 1)
        mov dword [ebp - 0x10], 0x0 ;i == 0
        .loop_for_m:
            mov ebx, dword [ebp - 0x10]
            cmp ebx, dword [ebp - 0x8]
            jge .after_loop_for_m
            mov eax, dword [ebp - 0x4]
            and eax, dword [ebp + 0x8] ;2^(t) & n
            cmp eax, 0x0 
            jg .increase_ans
            inc dword [ebp - 0x14] ;++number_of_prev_zeros
            shr dword [ebp - 0x4], 0x1 ;2^(t) -> 2^(t - 1)
            inc dword [ebp - 0x10] ;++i
            jmp .loop_for_m
            .increase_ans:
                mov eax, dword [ebp - 0x14]
                inc eax 
                mov ecx, dword [ebp + 0xC]
                sub ecx, eax ;ecx == k - (number_of_prev_zeros + 1)
                
                cmp ecx, 0x0
                jl .prepair
                
                mov eax, dword [ebp - 0x8]
                sub eax, dword [ebp - 0x10]
                sub eax, 0x1 ; m - i - 1
                
                ;call C(eax, ecx)
                sub esp, 0x4
                push ecx
                push eax
                call comb
                add esp, 0xC
                
                add dword [ebp - 0xC], eax ;ans += C(eax, ecx)
                
                .prepair:
                    inc dword [ebp - 0x10] ;++i
                    shr dword [ebp - 0x4], 0x1 ;2^(t) -> 2 ^(t - 1)
                    jmp .loop_for_m  
    .after_loop_for_m:
        mov ebx, dword [ebp - 0x14] ;number of previous zeros
        cmp ebx, dword [ebp + 0xC] 
        je .add_1
        jmp .next_step
        .add_1:
            inc dword [ebp - 0xC]
        .next_step:
            mov eax, dword [ebp - 0xC]
            jmp .epilogue
    .make_ans_zero:
        mov eax, 0x0
        jmp .epilogue
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
        
    .prepair_k:
        mov eax, 0x0
        cmp dword [ebp - 0x8], 0x20
        jge .output
    .call_function:
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call number_of_zeros
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
     