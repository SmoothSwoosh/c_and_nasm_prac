%include "io.inc"

extern printf, scanf

section .data
format_in db '%d', 0x0
format_out db '%s', 0x0
yes db 'YES', 0x0
no db 'NO', 0x0

%define base 0x38

section .text
in_rectangle:
    .prologue: 
        push ebp ;C
        mov ebp, esp ;8 
        sub esp, base ;for 5 points (x, y) and min(x), min(y), max(x), max(y)
        mov dword [ebp - 0x10], 0x2710 ;min(x) == 10000
        mov dword [ebp - 0xC], 0x2710 ;min(y) == 10000
        mov dword [ebp - 0x8], 0xFFFFD8F0 ;max(x) == -10000
        mov dword [ebp - 0x4], 0xFFFFD8F0 ;max(y) == -10000
    mov ebx, 0x0 ;i == 0
    .input_points:
        cmp ebx, 0xA
        jl .read
        jmp .after_input
        .read:
            ;x
            lea eax, [ebp + 0x4 * ebx - base]
            sub esp, 0x8 ; align stack
            push eax ;0
            push format_in ;C
            call scanf ;8
            add esp, 0x10
            inc ebx ;++i
            ;y
            lea eax, [ebp + 0x4 * ebx - base]
            sub esp, 0x8
            push eax
            push format_in
            call scanf
            add esp, 0x10 ;0
            inc ebx ;++i
            jmp .input_points
    .after_input:
        mov ebx, 0x0 ;i == 0
        .search_min_max:
            cmp ebx, 0x8
            jl .compare
            jmp .after_search
            .compare:
                ;for min(x) and max(x)
                mov eax, dword [ebp + 0x4 * ebx - base]
                cmp eax, dword [ebp - 0x10]
                jl .make_min_x
                .after_make_min_x:
                cmp eax, dword [ebp - 0x8]
                jg .make_max_x
                .after_make_max_x:
                inc ebx
                
                ;for min(y) and max(y)
                mov eax, dword [ebp + 0x4 * ebx - base]
                cmp eax, dword [ebp - 0xC]
                jl .make_min_y
                .after_make_min_y:
                cmp eax, dword [ebp - 0x4]
                jg .make_max_y
                .after_make_max_y:
                inc ebx
                jmp .search_min_max
                
                .make_min_x:
                    mov dword [ebp - 0x10], eax
                    jmp .after_make_min_x
                .make_max_x:
                    mov dword [ebp - 0x8], eax
                    jmp .after_make_max_x
                .make_min_y:
                    mov dword [ebp - 0xC], eax
                    jmp .after_make_min_y
                .make_max_y:
                    mov dword [ebp - 0x4], eax
                    jmp .after_make_max_y
                
                
    .after_search:
        mov eax, dword [ebp + 0x20 - base] ;point_x
        cmp eax, dword [ebp - 0x10]
        jle .output_no
        mov eax, dword [ebp + 0x20 - base] ;point_x
        cmp eax, dword [ebp - 0x8]
        jge .output_no
        mov eax, dword [ebp + 0x24 - base] ;point_y
        cmp eax, dword [ebp - 0xC]
        jle .output_no
        mov eax, dword [ebp + 0x24 - base] ;point_y
        cmp eax, dword [ebp - 0x4]
        jge .output_no
        jmp .output_yes
    .output_yes:
        sub esp, 0x8
        push yes
        push format_out
        call printf
        add esp, 0x10
        jmp .epilogue
    .output_no:
        sub esp, 0x8
        push no
        push format_out
        call printf
        add esp, 0x10
        jmp .epilogue
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
        sub esp, 0x0
    .call_function:
        call in_rectangle
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret