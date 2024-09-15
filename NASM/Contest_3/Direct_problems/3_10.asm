%include "io.inc"

extern printf, scanf

section .data
format db '%u ', 0x0

section .text
gcd:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .if_b_0:
        cmp dword [ebp + 0xC], 0x0
        jne .recurse
        mov eax, dword [ebp + 0x8]
        jmp .epilogue
    .recurse:
        mov eax, dword [ebp + 0x8]
        xor edx, edx
        div dword [ebp + 0xC]
        
        ;call gcd(b, mod(a / b))
        sub esp, 0x8
        push edx
        push dword [ebp + 0xC]
        call gcd
        add esp, 0x10
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
lcm:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .call_gcd:
        sub esp, 0x8
        push dword [ebp + 0xC]
        push dword [ebp + 0x8]
        call gcd
        add esp, 0x10 ;eax == gcd(y1, y2)
        
        push eax ;retain gcd
        mov eax, dword [ebp + 0x8]
        mul dword [ebp + 0xC]
        pop ebx 
        xor edx, edx
        div ebx ;eax == lcm(y1, y2)
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

add_fractions:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .sum_fract:
        ;call lcm(y1, y2)
        sub esp, 0x8
        push dword [ebp + 0x14]
        mov ebx, dword [ebp + 0xC] ;take address of 2nd arg
        push dword [ebx]
        call lcm
        add esp, 0x10 ;eax == lcm(y1, y2)
        
        push eax ;reserve lcm
        
        xor edx, edx
        mov ebx, dword [ebp + 0xC] ;take address of 2nd arg
        div dword [ebx] ;eax == lcm / y1
        mov ebx, dword [ebp + 0x8] ;take address of 1st arg
        mul dword [ebx]
        mov dword [ebx], eax ;new_x1 == x1 * lcm / y1
        
        pop eax ;get lcm back in eax
        push eax ;retain lcm
        
        xor edx, edx
        div dword [ebp + 0x14] ;eax == lcm / y2
        mul dword [ebp + 0x10]
        mov dword [ebp + 0x10], eax ;new_x2 = x2 * lcm / y2
        
        add dword [ebx], eax; ans_x == new_x1 + new_x2
        pop eax ;get lcm back in eax
        mov ebx, dword [ebp + 0xC] ;take address of 2nd arg
        mov dword [ebx], eax ;ans_y == lcm
    .make_irreducible:
        ;call gcd(ans_x, ans_y)
        sub esp, 0x8
        mov ebx, dword [ebp + 0xC]
        push dword [ebx]
        mov ebx, dword [ebp + 0x8]
        push dword [ebx]
        call gcd
        add esp, 0x10
        
        mov ecx, eax ;ebx == gcd
        ;make ans_x == ans_x / gcd
        xor edx, edx
        mov eax, dword [ebx]
        div ecx 
        mov dword [ebx], eax
        
        mov ebx, dword [ebp + 0xC]
        ;make ans_y == ans_y / gcd
        xor edx, edx
        mov eax, dword [ebx]
        div ecx 
        mov dword [ebx], eax       
    .epilogue: 
        xor eax, eax
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
        sub esp, 0x14 ;for n, x, y, ans_x and ans_y
    .input_n:
        sub esp, 0x4
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0xC
    mov ebx, 0x0 ;i == 0
    mov dword [ebp - 0x10], 0x0 ;ans_x == 0
    mov dword [ebp - 0x14], 0x1 ;ans_y == 1
    .loop:
        cmp ebx, dword [ebp - 0x4]
        jge .output
        
        ;input x
        sub esp, 0x4
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0xC
        
        ;input y
        sub esp, 0x4
        lea eax, [ebp - 0xC]
        push eax
        push format
        call scanf
        add esp, 0xC

        ;call function
        sub esp, 0xC
        push dword [ebp - 0xC]
        push dword [ebp - 0x8]
        lea eax, [ebp - 0x14]
        push eax
        lea eax, [ebp - 0x10]
        push eax
        call add_fractions
        add esp, 0x1C
       
        inc ebx ;++i
        jmp .loop
    .output:
        ;output x
        sub esp, 0x4
        push dword [ebp - 0x10]
        push format
        call printf
        add esp, 0xC
        
        ;output y
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
    
    