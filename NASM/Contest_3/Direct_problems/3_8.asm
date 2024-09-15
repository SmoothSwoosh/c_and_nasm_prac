%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0

section .text
sum_of_digits:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4 ;for number
        push ebx
    mov eax, 0x0 ;ans == 0
    mov ebx, dword [ebp + 0x8]
    mov dword [ebp - 0x4], ebx ;number == n
    .loop:
        cmp dword [ebp - 0x4], 0x0 ;compare number with 0
        je .epilogue
        push eax ;retain ans
        xor edx, edx
        mov eax, dword [ebp - 0x4]
        div dword [ebp + 0xC] ;edx == mod (number / k), eax == div(number / k)
        
        mov dword [ebp - 0x4], eax ;number == div(number / k)
        
        pop eax ;get ans back
        add eax, edx ;ans += mod (number / k), i.e. ans += last digit
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
        sub esp, 0x8 ;for n and k
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
    mov eax, dword [ebp - 0x4] ;ans == n
    .loop:
        push eax ;retain ans
        ;call sum of digits for number
        sub esp, 0xC
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call sum_of_digits
        add esp, 0x14 ;eax == sum of digits of number in decimal number system
        
        cmp eax, dword [ebp - 0x4] ;compare current with previous number
        je .add_and_output ;if equal
        
        mov dword [ebp - 0x4], eax 
        pop eax ;get ans back
        add eax, dword [ebp - 0x4] ;ans += new_sum
        jmp .loop
    .add_and_output:
        ;add to ans last number
        pop eax ;get preserved ans
        add eax, dword [ebp - 0x4] ;ans += last_number
        
        ;output ans
        push eax
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret