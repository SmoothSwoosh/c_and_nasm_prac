%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0

section .text
insufficient:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4 ;for sum of divisors
        push ebx
    mov dword [ebp - 0x4], 0x0 ;sum == 0
    mov ebx, 0x1 ;i == 1
    .loop:
        cmp ebx, dword [ebp + 0x8]
        jge .make_eax
        
        xor edx, edx
        mov eax, dword [ebp + 0x8]
        div ebx
        
        cmp edx, 0x0 ;compare mod (n / i) with 0
        jne .prepair_for_next_it
        add dword [ebp - 0x4], ebx
        
        .prepair_for_next_it:
            inc ebx ;++i
        jmp .loop
    .make_eax:
        mov ebx, dword [ebp + 0x8]
        cmp ebx, dword [ebp - 0x4]
        jg .make_eax_yes
        mov eax, 0x0 ;not insufficient
        jmp .epilogue
    .make_eax_yes:
        mov eax, 0x1 ;insufficient
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
        sub esp, 0x8 ;for k and cur_count
    .input_k:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    mov ebx, 0x1 ;i == 1
    mov dword [ebp - 0x8], 0x0 ;cur_count == 0
    .loop:
        ;call function 
        sub esp, 0x4
        push ebx
        call insufficient
        add esp, 0x8
 
        cmp eax, 0x1 ;eax == 1 if number is insufficient
        jne .prepair_for_next_it
        inc dword [ebp - 0x8] ;else: inc current count
        
        mov eax, dword [ebp - 0x8]
        cmp eax, dword [ebp - 0x4]
        je .output
        
        .prepair_for_next_it:
            inc ebx ;++i
        jmp .loop
    .output:
        push ebx
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret