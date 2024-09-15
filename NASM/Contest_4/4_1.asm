%include "io.inc"

extern printf, scanf

section .data
format_in db '%u', 0x0
format_out db '0x%08X', 0xA, 0x0

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x4 ;for new element
    .just_do_it:    
        .for:
            sub esp, 0x4
            lea eax, [ebp - 0x4]
            push eax
            push format_in
            call scanf
            add esp, 0xC
            
            cmp eax, 0xFFFFFFFF ;compare with -1
            je .epilogue ;if we didnt read anything
            
            sub esp, 0x4
            push dword [ebp - 0x4]
            push format_out
            call printf
            add esp, 0xC
            
            jmp .for
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret