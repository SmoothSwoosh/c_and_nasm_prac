%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0
mod dd 0x7DB ;2011

section .text
concat:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov ebx, 0x0 ;ebx == count of digits in 2nd number
    mov eax, dword [ebp + 0xC] ;2nd number
    ;find count of digits in 2nd number in system k
    .while_second_more_than_0:
        cmp eax, 0x0
        je .after_while
        inc ebx ;++count
        
        xor edx, edx
        div dword [ebp + 0x10] ;eax == div (eax / k)
        
        jmp .while_second_more_than_0
    .after_while:
        cmp ebx, 0x0
        je .add_1
        jmp .after_add
        .add_1:
            inc ebx ;++count
        .after_add:
            mov eax, 0x1
            ;raise to power of k
            .loop:
                cmp ebx, 0x0
                je .after_loop 
                
                dec ebx ;--count
                mul dword [ebp + 0x10] ;eax *= k
                jmp .loop
            .after_loop:
                mul dword [ebp + 0x8] ;eax *= first
                add eax, dword [ebp + 0xC] ;eax == first # second (ans)
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
        sub esp, 0x14 ;for k, n, A, Xi-1 and Xi
    .input:
        ;k
        sub esp, 0x4
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0xC
        
        ;n
        sub esp, 0x4
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0xC
        
        ;A 
        sub esp, 0x4
        lea eax, [ebp - 0xC]
        push eax
        push format
        call scanf
        add esp, 0xC
    .make_X0:
        xor edx, edx
        mov eax, dword [ebp - 0xC]
        div dword [mod]
        mov dword [ebp - 0x10], edx ;X0 == A mod 2011
    .make_X1:
        push dword [ebp - 0x4]
        push dword [ebp - 0x10]
        push dword [ebp - 0x10]
        call concat
        add esp, 0xC
        
        xor edx, edx
        div dword [mod]
        mov dword [ebp - 0x14], edx ;X1 == (X0 # X0) mod 2011
    dec dword [ebp - 0x8] ;--n
    mov ebx, 0x0 ;i == 0
    .main_loop:
        cmp ebx, dword [ebp - 0x8]
        je .output
        
        ;call concat(Xi-1, Xi)
        push dword [ebp - 0x4]
        push dword [ebp - 0x10]
        push dword [ebp - 0x14]
        call concat
        add esp, 0xC
        
        xor edx, edx
        div dword [mod]
        mov eax, edx
        
        mov ecx, dword [ebp - 0x14]
        mov dword [ebp - 0x10], ecx ;Xi-1 == Xi
        mov dword [ebp - 0x14], eax ;Xi == Xi+1

        inc ebx ;++i
        jmp .main_loop
    .output:
        sub esp, 0x4
        push dword [ebp - 0x14]
        push format
        call printf
        add esp, 0xC
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret