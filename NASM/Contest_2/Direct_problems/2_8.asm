%include "io.inc"

extern printf, scanf

section .data
format db '%d ', 0x0
backslash db '%s', 0xA , 0x0

%define base_a 0x61A80
%define base_b 0x493E0
%define base_c 0x30D40

section .text
mul_matrix:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, base_a ;for 3 arrays
        sub esp, 0xC ;for N * M, M * K and N * K
        sub esp, 0xC ;for 3 loops
        sub esp, 0xC ;for (i * K + j), (i * M + k) and (k * K + j)
    .input_a:
        mov eax, dword [ebp + 0x8]
        mul dword [ebp + 0xC]
        mov dword [ebp - 0x4], eax ;N * M
  
        mov ebx, 0x0 ;i == 0
        .loop_a:
            cmp ebx, dword [ebp - 0x4]
            jge .input_b
            sub esp, 0x4
            lea eax, [ebp + 0x4 * ebx - base_a]
            push eax
            push format
            call scanf
            add esp, 0xC
            inc ebx ;++i
            jmp .loop_a
    .input_b:
        mov eax, dword [ebp + 0xC]
        mul dword [ebp + 0x10]
        mov dword [ebp - 0x8], eax ;M * K
           
        mov ebx, 0x0 ;i == 0
        .loop_b:
            cmp ebx, dword [ebp - 0x8]
            jge .multiplication
            sub esp, 0x4
            lea eax, [ebp + 0x4 * ebx - base_b]
            push eax
            push format
            call scanf
            add esp, 0xC
            inc ebx ;++i
            jmp .loop_b  
    .multiplication:
        mov eax, dword [ebp + 0x8]
        mul dword [ebp + 0x10] 
        mov dword [ebp - 0xC], eax ;N * K
        
        mov dword [ebp - 0x10], 0x0 ;i == 0
        .loop_i:
            mov eax, dword [ebp - 0x10]
            cmp eax, dword [ebp + 0x8] ;compare with N
            jge .output
            mov dword [ebp - 0x14], 0x0 ;j == 0
            .loop_j:
                mov eax, dword [ebp - 0x14]
                cmp eax, dword [ebp + 0x10] ;compare with K
                jl .next_step_j
                inc dword [ebp - 0x10] ;++i
                jmp .loop_i
                .next_step_j:
                    ;find index for c[i][j] = ebp - base_c + 0x4 * (i * K + j), c[i][j] == 0
                    mov eax, dword [ebp - 0x10]
                    mul dword [ebp + 0x10]
                    add eax, dword [ebp - 0x14]
                    mov dword [ebp - 0x1C], eax ;i * K + j
                    mov dword [ebp + 0x4 * eax - base_c], 0x0 ;c[i][j] == 0
                    
                    mov dword [ebp - 0x18], 0x0 ;k == 0
                    .loop_k:
                        mov eax, dword [ebp - 0x18]
                        cmp eax, dword [ebp + 0xC] ;compare with M
                        jl .next_step_k
                        inc dword [ebp - 0x14] ;++j
                        jmp .loop_j
                        .next_step_k:
                            ;find index for a[i][k] = ebp - base_a + 0x4 * (i * M + k)
                            mov eax, dword [ebp - 0x10]
                            mul dword [ebp + 0xC]
                            add eax, dword [ebp - 0x18]
                            mov dword [ebp - 0x20], eax ;i * M + k
                            
                            ;find index for b[k][j] = ebp - base_b + 0x4 * (k * K + j)
                            mov eax, dword [ebp - 0x18]
                            mul dword [ebp + 0x10]
                            add eax, dword [ebp - 0x14]
                            mov dword [ebp - 0x24], eax ;k * K + j
                            
                            ;c[i][j] += a[i][k] * b[k][j]
                            mov ebx, dword [ebp - 0x20] ;i * M + k
                            mov ecx, dword [ebp - 0x24] ;k * K + j
                            mov eax, dword [ebp + 0x4 * ebx - base_a]
                            imul dword [ebp + 0x4 * ecx - base_b]
                            mov ebx, dword [ebp - 0x1C] ;i * K + j
                            add dword [ebp + 0x4 * ebx - base_c], eax
                            
                            inc dword [ebp - 0x18] ;++k
                            jmp .loop_k
    .output:
        mov dword [ebp - 0x10], 0x0 ;i == 0
        .loop_c_i:
            mov eax, dword [ebp - 0x10]
            cmp eax, dword [ebp + 0x8] ;compare with N
            jge .epilogue
            
            mov dword [ebp - 0x14], 0x0 ;j == 0
            .loop_c_j:
                mov eax, dword [ebp - 0x14]
                cmp eax, dword [ebp + 0x10] ;compare with K
                jl .next_step_loop_c_j
                NEWLINE
                inc dword [ebp - 0x10] ;++i
                jmp .loop_c_i
                .next_step_loop_c_j:
                    ;find index for c[i][j] = ebp - base + 0x4 * (i * K + j)
                    mov eax, dword [ebp - 0x10]
                    mul dword [ebp + 0x10]
                    add eax, dword [ebp - 0x14] ;i * K + j
                    
                    sub esp, 0x4
                    push dword [ebp + 0x4 * eax - base_c]
                    push format
                    call printf
                    add esp, 0xC
                    inc dword [ebp - 0x14] ;++j
                    jmp .loop_c_j
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
        sub esp, 0xC
    .input:
        ;n
        sub esp, 0xC
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x14
        
        ;m
        sub esp, 0xC
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x14
        
        ;k
        sub esp, 0xC
        lea eax, [ebp - 0xC]
        push eax
        push format
        call scanf
        add esp, 0x14
    .call_function:
        sub esp, 0x8
        push dword [ebp - 0xC]
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call mul_matrix
        add esp, 0x14
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret