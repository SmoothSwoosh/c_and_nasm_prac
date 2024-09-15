%include "io.inc"

extern printf, scanf

section .data
format db '%u ', 0x0

section .bss
arr resd 0xA

section .text
factorial:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    cmp dword [ebp + 0x8], 0x0
    je .make_ans_one
    mov eax, 0x1 ;ans == 1
    mov ebx, 0x1 ;factor == 1
    .loop:
        cmp ebx, dword [ebp + 0x8]
        jg .epilogue
        mul ebx ;ans *= i

        inc ebx ;++i
        jmp .loop
    .make_ans_one:
        mov eax, 0x1
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

placement:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .make_placement:
        ;lets take n!/(n - k)!
        ;call n!
        sub esp, 0xC
        push dword [ebp + 0x8]
        call factorial
        add esp, 0x10 ;eax == n!
        push eax
        
        ;call (n - k)!
        mov eax, dword [ebp + 0xC]
        sub esp, 0xC
        push eax
        call factorial 
        add esp, 0x10 ;eax == (n - k)!
        
        pop ebx
        xchg ebx, eax ;eax == n!, ebx == (n - k)!
        xor edx, edx
        div ebx ;eax == n!/(n - k)!
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
        sub esp, 0xC ;for n, k and m
    .input:
        ;n
        sub esp, 0xC
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x14
        
        ;k 
        sub esp, 0xC
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x14
        
        ;m
        sub esp, 0xC
        lea eax, [ebp - 0xC]
        push eax
        push format
        call scanf
        add esp, 0x14     
    mov ebx, 0x1 ;i == 1
    .main_loop:
        ;check if last number
        cmp ebx, dword [ebp - 0x8] ;compare i with k
        je .output_last_number
        
        ;make eax == (n - i)!/(n - k)!
        sub esp, 0xC
        mov eax, dword [ebp - 0x4]
        sub eax, dword [ebp - 0x8] ;n - k
        push eax
        mov eax, dword [ebp - 0x4]
        sub eax, ebx ;n - i
        push eax
        call placement
        add esp, 0x14 ;eax == (n - i)!/(n - k)!
        
        ;search for first free number
        mov ecx, 0x0 ;j == 0
        .search_1:
            cmp dword [arr + 0x4 * ecx], 0x0
            je .after_search_1
            
            inc ecx ;++j
            jmp .search_1
        .after_search_1:    
            mov dword [arr + 0x4 * ecx], 0x1 ;make unfree
        
        .while_m_more_than_eax:
            cmp dword [ebp - 0xC], eax
            jle .output_number
            
            sub dword [ebp - 0xC], eax ;m -= eax
            
            mov dword [arr + 0x4 * ecx], 0x0 ;again free
            inc ecx ;++j
            ;search for first free number
            .search_2:
                cmp dword [arr + 0x4 * ecx], 0x0
                je .after_search_2
                
                inc ecx ;++j
                jmp .search_2
            .after_search_2:
                mov dword [arr + 0x4 * ecx], 0x1 ;make unfree
            jmp .while_m_more_than_eax
        
        .output_number:
            sub esp, 0xC
            inc ecx ;make number
            push ecx
            push format
            call printf
            add esp, 0x14

        inc ebx ;++i
        jmp .main_loop
    .output_last_number:
        mov ecx, 0x0 ;j == 0
        .side_loop:
            cmp dword [ebp - 0xC], 0x0 
            je .out_last
            
            ;find first free number
            .search_3:
                cmp dword [arr + 0x4 * ecx], 0x0
                je .after_search_3
                
                inc ecx ;++j
                jmp .search_3
            .after_search_3:
                mov dword [arr + 0x4 * ecx], 0x1 ;make unfree
            
            dec dword [ebp - 0xC] ;--order
            jmp .side_loop
        .out_last:
            ;output number
            sub esp, 0xC
            inc ecx ;make number
            push ecx
            push format
            call printf
            add esp, 0x14
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret