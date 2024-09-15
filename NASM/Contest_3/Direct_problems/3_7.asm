%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0
mod dd 0x7DB ;2011

section .bss
remainds resb 2011
index resb 2011

section .text
reverse_system:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov ebx, dword [ebp + 0x8] ;number == n
    mov eax, 0x0 ;ans == 0
    .loop:
        cmp ebx, 0x0
        je .epilogue
        mul dword [ebp + 0xC] ;ans *= k
        push eax ;retain ans
        mov eax, ebx 
        xor edx, edx
        div dword [ebp + 0xC] ;edx == last digit
        mov ebx, eax 
        
        pop eax ;get ans back into eax
        add eax, edx ;ans += last digit
        jmp .loop
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
        sub esp, 0x10 ;for k, n, A and Yi
    .input:
        ;k
        sub esp, 0x8
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x10
        
        ;n
        sub esp, 0x8
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x10
        
        ;A
        sub esp, 0x8
        lea eax, [ebp - 0xC]
        push eax
        push format
        call scanf
        add esp, 0x10
    .make_Y0:  
        mov eax, dword [ebp - 0xC]
        xor edx, edx
        div dword [mod]
        mov dword [ebp - 0x10], edx ;Y0 == A mod 2011
    mov ecx, dword [ebp - 0x10]
    mov dword [remainds + ecx], 0x1 ;mod 1
    mov dword [index + ecx], 0x0
    mov ebx, 0x0 ;i == 0
    .loop:
        cmp ebx, dword [ebp - 0x8] ;compare with n
        jge .output
        
        inc ebx ;++i
        mov eax, dword [ebp - 0x10]
        mul dword [ebp - 0x10] ;eax == Yi * Yi

        ;call function @(Yi * Yi)
        sub esp, 0x8
        push dword [ebp - 0x4]
        push eax
        call reverse_system
        add esp, 0x10 ;eax == @(Yi*Yi)
        
        xor edx, edx
        div dword [mod]
        mov dword [ebp - 0x10], edx ;Y(i+1) == @(Yi * Yi) mod 2011
        
        mov ecx, dword [ebp - 0x10] ;take Y(i + 1)
        cmp dword [remainds + ecx], 0x1 
        je .make_after_equal
        
        mov dword [remainds + ecx], 0x1 ;mod 1
        mov dword [index + ecx], ebx
        jmp .loop
    .make_after_equal:
        mov eax, dword [ebp - 0x8] ;n
        sub eax, ebx ;n - i
        sub ebx, dword [index + ecx] ;count in cycle
        xor edx, edx
        div ebx 
        mov dword [ebp - 0x8], edx ;new_n == (n - i) / count_in_cycle 
    .make_rest_loop:
        mov ebx, 0x0 ;i == 0
        .rest_loop:
            cmp ebx, dword [ebp - 0x8]
            jge .output
            
            inc ebx ;++i
            mov eax, dword [ebp - 0x10]
            mul dword [ebp - 0x10] ;eax == Yi * Yi
            
            ;call function @(Yi * Yi)
            sub esp, 0x8
            push dword [ebp - 0x4]
            push eax
            call reverse_system
            add esp, 0x10 ;eax == @(Yi*Yi)
            
            xor edx, edx
            div dword [mod]
            mov dword [ebp - 0x10], edx ;Y(i+1) == @(Yi * Yi) mod 2011
            jmp .rest_loop
    .output:
        sub esp, 0x8
        push dword [ebp - 0x10]
        push format
        call printf
        add esp, 0x10
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret