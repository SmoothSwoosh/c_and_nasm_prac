%include "io.inc"

CEXTERN fopen
CEXTERN fclose
CEXTERN fscanf

extern printf, scanf

section .data
file_name db 'data.in', 0x0
format_u db '%u', 0x0
state db 'r', 0x0

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x8 ;for new element and file pointer
    .open_file:
        push state
        push file_name
        call fopen
        add esp, 0x8
        mov dword [ebp - 0x8], eax ;file pointer
    .just_do_it:
        mov ebx, 0x0 ;ans == 0
        .input_loop:
            ;try to read smth from file
            sub esp, 0xC
            lea eax, [ebp - 0x4] ;address of new element
            push eax
            push format_u
            push dword [ebp - 0x8] ;file pointer
            call fscanf
            add esp, 0x18
            
            cmp eax, 0xFFFFFFFF
            je .output_ans
            inc ebx ;++ans
            
            jmp .input_loop
    .output_ans:
        push ebx
        push format_u
        call printf
        add esp, 0x8
    .close_file:
        sub esp, 0x4
        push dword [ebp - 0x8]
        call fclose
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret