%include "io.inc"

CEXTERN strstr

extern printf, scanf

section .data
format_in db '%s', 0x0
format_out_0 db '%d ', 0x0
format_out_n0 db '%d %d ', 0x0

%define base1 0x2000
%define base2 0x1000

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, base1
    .input:
        ;s1
        sub esp, 0x8
        lea eax, [ebp - base1]
        push eax
        push format_in
        call scanf
        add esp, 0x10
        
        ;s2
        sub esp, 0x8
        lea eax, [ebp - base2]
        push eax
        push format_in
        call scanf
        add esp, 0x10
    .just_do_it:
        ;does s1 contain s2 
        sub esp, 0x8
        lea eax, [ebp - base2]
        push eax
        lea eax, [ebp - base1]
        push eax
        call strstr
        add esp, 0x10
        
        cmp eax, 0x0
        jne .2_in_1
        
        ;does s2 contain s1 
        sub esp, 0x8
        lea eax, [ebp - base1]
        push eax
        lea eax, [ebp - base2]
        push eax
        call strstr
        add esp, 0x10
        
        cmp eax, 0x0
        jne .1_in_2
        
        ;so now ans == 0
        sub esp, 0x8
        push 0x0
        push format_out_0
        call printf
        add esp, 0x10
        jmp .epilogue
    .2_in_1:    
        sub esp, 0x4
        push 0x1
        push 0x2
        push format_out_n0
        call printf
        jmp .epilogue
    .1_in_2:
        sub esp, 0x4
        push 0x2
        push 0x1
        push format_out_n0
        call printf
        jmp .epilogue
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret 