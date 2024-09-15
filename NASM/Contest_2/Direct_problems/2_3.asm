%include "io.inc"

extern printf, scanf

section .data
format db '%d ', 0x0
backslash db '%d', 0xA , 0x0

%define first_base 0x3D0900 ;base of first array
%define second_base 0x1E8480 ;base of second array

section .text
find_extremums:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, first_base ;for 2 arrays
        sub esp, 0x14 ;for 3 elements, m and M
    mov dword [ebp - 0x8], 0x0
    mov dword [ebp - 0x4], 0x0
    .pre_loop:  
        ;read 2 elements
        sub esp, 0x4
        lea eax, [ebp - 0xC] ;third
        push eax
        push format
        call scanf
        add esp, 0xC
        
        sub esp, 0x4
        lea eax, [ebp - 0x10] ;second
        push eax
        push format
        call scanf
        add esp, 0xC
    mov ebx, 0x1 ;i == 1
    .loop:
        sub esp, 0x4
        lea eax, [ebp - 0x14] ;first
        push eax
        push format
        call scanf
        add esp, 0xC
        .check_first_for_min:
            mov eax, dword [ebp - 0x10]
            cmp eax, dword [ebp - 0x14]
            jl .check_second_for_min
            jmp .check_first_for_max
            .check_second_for_min:
                cmp eax, dword [ebp - 0xC]
                jl .inc_min
                jmp .after_comparisons
                .inc_min:
                    mov ecx, dword [ebp - 0x8]
                    mov dword [ebp + 0x4 * ecx - first_base], ebx
                    inc dword [ebp - 0x8]
                    jmp .after_comparisons
        .check_first_for_max:
            mov eax, dword [ebp - 0x10]
            cmp eax, dword [ebp - 0x14]
            jg .check_second_for_max
            jmp .after_comparisons    
            .check_second_for_max:
                cmp eax, dword [ebp - 0xC]
                jg .inc_max
                jmp .after_comparisons
                .inc_max:
                    mov ecx, dword [ebp - 0x4]
                    mov dword [ebp + 0x4 * ecx - second_base], ebx
                    inc dword [ebp - 0x4]
                    jmp .after_comparisons
        .after_comparisons:
        mov eax, dword [ebp - 0x10]
        mov dword [ebp - 0xC], eax ;third == second
        mov eax, dword [ebp - 0x14]
        mov dword [ebp - 0x10], eax ;second == first
        inc ebx ;++i
        cmp ebx, dword [ebp + 0x8]
        jge .after_loop
        jmp .loop
    mov eax, dword [ebp + 0x8]
    cmp eax, 0x2
    jle .if_lower_3
    .after_loop:
        .out_min:   
            sub esp, 0x4
            push dword [ebp - 0x8] ;m \n
            push backslash
            call printf
            add esp, 0xC

            mov ebx, 0x0 ;i == 0
            .output_minimums:
                cmp ebx, dword [ebp - 0x8]
                jge .out_max
                sub esp, 0x4
                push dword [ebp + 0x4 * ebx - first_base]
                push format
                call printf
                add esp, 0xC
                inc ebx ;++i
                jmp .output_minimums
        .out_max:
            NEWLINE
            sub esp, 0x4
            push dword [ebp - 0x4] ;M \n
            push backslash
            call printf
            add esp, 0xC

            mov ebx, 0x0 ;i == 0
            .output_maximums:
                cmp ebx, dword [ebp - 0x4]
                jge .epilogue
                sub esp, 0x4
                push dword [ebp + 0x4 * ebx - second_base]
                push format
                call printf
                add esp, 0xC
                inc ebx ;++i
                jmp .output_maximums
    .if_lower_3:
        mov eax, 0x0
        sub esp, 0x4
        push eax
        push backslash
        call printf
        add esp, 0xC
        
        mov eax, 0x0
        sub esp, 0x4
        push eax
        push backslash
        call printf
        add esp, 0xC
    .epilogue:
        xor eax, eax
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
        sub esp, 0x4
    .input_n:
        sub esp, 0x4
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0xC
    .call_function:
        sub esp, 0x8
        push dword [ebp - 0x4]
        call find_extremums
        add esp, 0xC
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret