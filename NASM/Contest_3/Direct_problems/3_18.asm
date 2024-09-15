%include "io.inc"

extern printf, scanf

section .data
format db '%s', 0x0
mod dd 0xA

%define base_a 0x280
%define base_b 0x200
%define base_c 0x180
%define base_ans1 0x100
%define base_ans2 0x80

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x280 ;for a, b, c, ans1 and ans2
    .input:
        ;a
        sub esp, 0x8
        lea eax, [ebp - base_a]
        push eax
        push format
        call scanf
        add esp, 0x10
        
        ;b
        sub esp, 0x8
        lea eax, [ebp - base_b]
        push eax
        push format
        call scanf
        add esp, 0x10
        
        ;c
        sub esp, 0x8
        lea eax, [ebp - base_c]
        push eax
        push format
        call scanf
        add esp, 0x10
    .make_flag:
        mov byte [ebp - 0xA], 0x0 ;it serves minuses
    .take_lengths:
        mov ebx, 0x0 ;i == 0
        mov byte [ebp - 0x7], 0x0 ;len(a) == 0
        cmp byte [ebp - base_a], '-'
        jne .for_1l
        inc byte [ebp - 0x7] ;++len(a)
        inc byte [ebp - 0xA] ;++minuses
        mov byte [ebp - base_a], '0' ;'0'
        inc ebx ;++i
        .for_1l:
            cmp byte [ebp - base_a + ebx], 0x0
            je .after_for_1l
            
            inc byte [ebp - 0x7] ;++len(a)
            inc ebx ;++i    
            jmp .for_1l
        .after_for_1l:   
            ;make some fresh and relax :D
            dec byte [ebp - 0x7] ;len(a) - 1
            
        mov ebx, 0x0 ;i == 0
        mov byte [ebp - 0x6], 0x0 ;len(b) == 0
        cmp byte [ebp - base_b], '-'
        jne .for_2l
        inc byte [ebp - 0x6] ;++len(b)
        inc byte [ebp - 0xA] ;++minuses
        mov byte [ebp - base_b], '0' ;'0'
        inc ebx ;++i
        .for_2l:
                cmp byte [ebp - base_b + ebx], 0x0
                je .after_for_2l
                
                inc byte [ebp - 0x6] ;++len(b)
                inc ebx ;++len
                jmp .for_2l
        .after_for_2l:
                dec byte [ebp - 0x6]
    .zeroing_ans1:
        mov ebx, 0x0 ;i == 0
        .tmp_for1:
            cmp ebx, 0x80 ;compare with 128
            je .zeroing_ans2
            mov byte [ebp - base_ans1 + ebx], 0x0
            
            inc ebx ;++i
            jmp .tmp_for1
    .zeroing_ans2:
        mov ebx, 0x0 ;i == 0
        .tmp_for2:
            cmp ebx, 0x61 ;compare with 97
            je .make_1multiplication
            mov byte [ebp - base_ans2 + ebx], 0x0
            
            inc ebx ;++i
            jmp .tmp_for2
    .make_1multiplication:
        mov byte [ebp - 0x1], 0x0 ;pos1
        mov bl, byte [ebp - 0x7]
        .main_1for:
            cmp ebx, 0x0
            jl .make_2multiplication

            mov byte [ebp - 0x3], 0x0 ;carry
            mov al, byte [ebp - base_a + ebx]
            sub al, '0' 
            mov byte [ebp - 0x4], al ;a[i] - '0'
            
            mov byte [ebp - 0x2], 0x0 ;pos2
            movzx ecx, byte [ebp - 0x6] ;len(b) - 1
            .small_1for:
                cmp ecx, 0x0
                jl .prepair1
                
                mov al, byte [ebp - base_b + ecx]
                sub al, '0'
                mov byte [ebp - 0x5], al ;b[j] - '0'
                
                mov al, byte [ebp - 0x4]
                mul byte [ebp - 0x5] ;a[i] * b[j]
                xor edx, edx
                mov dl, byte [ebp - 0x1]
                add dl, byte [ebp - 0x2] ;pos1 + pos2
                add al, byte [ebp - base_ans1 + edx]
                add al, byte [ebp - 0x3] ;al == a[i] * b[j] + ans[pos1 + pos2] + carry
                
                push edx ;retain pos1 + pos2
                xor edx, edx
                div dword [mod]
                mov byte [ebp - 0x3], al ;carry == al / 10
                mov eax, edx
                pop edx
                mov byte [ebp - base_ans1 + edx], al 
                
                inc byte [ebp - 0x2] ;++pos2
                inc edx
                dec ecx ;--j
                jmp .small_1for
            .prepair1:
                cmp byte [ebp - 0x3], 0x0
                jg .add_carry
                jmp .after_add
                .add_carry:
                    mov al, byte [ebp - 0x3] ;carry
                    add byte [ebp - base_ans1 + edx], al ;ans[i + j] += carry
                .after_add:
                    dec ebx ;--i
                    inc byte [ebp - 0x1] ;++pos1
                jmp .main_1for
    .make_2multiplication:
        .take_ans_len:
            mov al, byte [ebp - 0x6] ;len(a) - 1
            add al, byte [ebp - 0x7] ;len(a) + len(b) - 2
            inc al 
            mov byte [ebp - 0x8], al ;len(ans) - 1
        .take_c_len:
            mov ebx, 0x0 ;i == 0
            mov byte [ebp - 0x9], 0x0 ;len(c) == 0
            cmp byte [ebp - base_c], '-'
            jne .for_3l
            inc byte [ebp - 0x9] ;++len(c)
            inc byte [ebp - 0xA] ;++minuses
            mov byte [ebp - base_c], '0' ;'0'
            inc ebx ;++i
            .for_3l:
                cmp byte [ebp - base_c + ebx], 0x0
                je .after_for_3l
                
                inc byte [ebp - 0x9] ;++len(c)
                inc ebx ;++len
                jmp .for_3l
            .after_for_3l:
                dec bl
                mov byte [ebp - 0x9], bl ;retain len(c) - 1
        .make_2mult:
            mov byte [ebp - 0x1], 0x0 ;pos1
            mov ebx, 0x0 ;i == 0
            .main_2for:
                cmp bl, byte [ebp - 0x8] ;compare with len(ans) - 1
                jg .output
                
                mov byte [ebp - 0x3], 0x0 ;carry
                mov al, byte [ebp - base_ans1 + ebx] 
                mov byte [ebp - 0x4], al ;ans[i] - '0'
                
                mov byte [ebp - 0x2], 0x0 ;pos2
                movzx ecx, byte [ebp - 0x9] ;len(c) - 1
                .small_2for:
                    cmp ecx, 0x0
                    jl .prepair2
                    
                    mov al, byte [ebp - base_c + ecx]
                    sub al, '0'
                    mov byte [ebp - 0x5], al ;c[j] - '0'
                    
                    mov al, byte [ebp - 0x4]
                    mul byte [ebp - 0x5] ;ans[i] * c[j]
                    xor edx, edx
                    mov dl, byte [ebp - 0x1]
                    add dl, byte [ebp - 0x2] ;pos1 + pos2
                    add al, byte [ebp - base_ans2 + edx]
                    add al, byte [ebp - 0x3] ;al == ans[i] * c[j] + ans[pos1 + pos2] + carry
                    
                    push edx ;retain pos1 + pos2
                    xor edx, edx
                    div dword [mod]
                    mov byte [ebp - 0x3], al ;carry == al / 10
                    mov eax, edx
                    pop edx
                    mov byte [ebp - base_ans2 + edx], al 
                    
                    inc byte [ebp - 0x2] ;++pos2
                    inc edx
                    dec ecx ;--j
                    jmp .small_2for
                .prepair2:
                    cmp byte [ebp - 0x3], 0x0
                    jg .add_carry2
                    jmp .after_add2
                    .add_carry2:
                        mov al, byte [ebp - 0x3] ;carry
                        add byte [ebp - base_ans2 + edx], al ;ans[i + j] += carry
                    .after_add2:
                        inc ebx ;++i
                        inc byte [ebp - 0x1] ;++pos1
                    jmp .main_2for     
    .output:
        mov ebx, 0x0 ;i ==0
        mov ecx, 0x0 ;last_nz
        .fff:
            cmp ebx, 0x61 ;compare with 97
            je .make_output
            
            cmp byte [ebp - base_ans2 + ebx], 0x0
            je .next_it
            mov ecx, ebx
            
            .next_it:
                inc ebx ;++i
            jmp .fff
        .make_output:
            mov al, byte [ebp - 0xA] 
            xor edx, edx
            mov ebx, 0x2
            div ebx ;edx == mod(count_minuses / 2) 
            cmp edx, 0x1 
            je .output_minus
            jmp .after_minus
            .output_minus:
                PRINT_CHAR '-'
            .after_minus:
                mov ebx, ecx 
                .out_for:
                    cmp ebx, 0x0
                    jl .epilogue
                    
                    PRINT_DEC 1, [ebp - base_ans2 + ebx]
                    
                    dec ebx ;--i
                    jmp .out_for
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret