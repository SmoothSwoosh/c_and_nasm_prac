%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0

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

take_abs:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
    .make_abs:
        mov ecx, eax
        sar ecx, 0x1F
        xor eax, ecx
        sub eax, ecx
    .epilogue:
        mov esp, ebp
        pop ebp
        ret

area_of_triangle:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0 
        push ebx
    .find_area:
        mov eax, dword [ebp + 0x10] ;x2
        sub eax, dword [ebp + 0x8] ;x2 - x1
        push eax
        
        mov eax, dword [ebp + 0x1C] ;y3
        sub eax, dword [ebp + 0xC] ;y3 - y1
        pop ebx
        imul ebx ;eax == (x2 - x1) * (y3 - y1)
        push eax
        
        mov eax, dword [ebp + 0x14] ;y2
        sub eax, dword [ebp + 0xC] ;y2 - y1
        push eax
        
        mov eax, dword [ebp + 0x18] ;x3
        sub eax, dword [ebp + 0x8] ;x3 - x1
        pop ebx
        imul ebx ;eax == (x3 - x1) * (y2 - y1)
        pop ebx
        
        sub ebx, eax
        mov eax, ebx ;eax == area of parallelogram
        
        ;abs(eax)
        sub esp, 0xC
        push eax
        call take_abs
        add esp, 0x10 ;ans == abs(ans)
        
        mov ebx, 0x2
        xor edx, edx
        div ebx ;eax == S_paral / 2
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
count_side:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .count:
        mov eax, dword [ebp + 0x8] ;x1
        sub eax, dword [ebp + 0x10] ;x1 - x2
        
        ;make abs(x1 - x2)
        sub esp, 0xC
        push eax
        call take_abs
        add esp, 0x10
        push eax
        
        mov eax, dword [ebp + 0xC] ;y1
        sub eax, dword [ebp + 0x14] ;y1 - y2
        
        ;make abs(y1 - y2)
        sub esp, 0xC
        push eax
        call take_abs
        add esp, 0x10
        
        pop ebx
        
        ;call gcd(eax, ebx)
        sub esp, 0x8
        push ebx
        push eax
        call gcd
        add esp, 0x10 ;eax == gcd(eax, ebx)
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
count_in_triangle:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4 ;for tmp_ans
        push ebx
    mov dword [ebp - 0x4], 0x0 ;ans == 0
    count_1_side:
        ;call count on side 1 - 2
        sub esp, 0xC
        push dword [ebp + 0x14]
        push dword [ebp + 0x10]
        push dword [ebp + 0xC]
        push dword [ebp + 0x8]
        call count_side
        add esp, 0x1C
        
        add dword [ebp - 0x4], eax ;ans += gcd(eax, ebx)
    count_2_side:
        ;call count on side 3 - 2
        sub esp, 0xC
        push dword [ebp + 0x1C]
        push dword [ebp + 0x18]
        push dword [ebp + 0x14]
        push dword [ebp + 0x10]
        call count_side
        add esp, 0x1C
        
        add dword [ebp - 0x4], eax ;ans += gcd(eax, ebx)
    count_3_side:
        ;call count on side 1 - 3
        sub esp, 0xC
        push dword [ebp + 0x1C]
        push dword [ebp + 0x18]
        push dword [ebp + 0xC]
        push dword [ebp + 0x8]
        call count_side
        add esp, 0x1C
        
        add dword [ebp - 0x4], eax ;ans += gcd(eax, ebx)
    .make_ans_in_eax:
        mov eax, dword [ebp - 0x4] ;eax == ans
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
        sub esp, 0x18 ;for 6 coords
    .input_points:
        ;point 1
        ;x
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
        ;y
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8
        
        ;point 2
        ;x
        lea eax, [ebp - 0xC]
        push eax
        push format
        call scanf
        add esp, 0x8
        ;y
        lea eax, [ebp - 0x10]
        push eax
        push format
        call scanf
        add esp, 0x8
        
        ;point 3
        ;x
        lea eax, [ebp - 0x14]
        push eax
        push format
        call scanf
        add esp, 0x8
        ;y
        lea eax, [ebp - 0x18]
        push eax
        push format
        call scanf
        add esp, 0x8
    .find_area:
        ;this area would be (S_parallelogram div 2)
        push dword [ebp - 0x18]
        push dword [ebp - 0x14]
        push dword [ebp - 0x10]
        push dword [ebp - 0xC]
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call area_of_triangle
        add esp, 0x8 ;eax == area of triangle
        push eax ;retain area
    .find_count_points_in_triangle:
        push dword [ebp - 0x18]
        push dword [ebp - 0x14]
        push dword [ebp - 0x10]
        push dword [ebp - 0xC]
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call count_in_triangle
        add esp, 0x18 
    .find_ans:
        xor edx, edx
        mov ecx, 0x2
        div ecx 
        mov ebx, eax ;retain count / 2
        pop eax ;get back area into eax
        sub eax, ebx
        inc eax ;eax += 1, cause ans = 1 + S - count / 2
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