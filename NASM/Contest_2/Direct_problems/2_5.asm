%include "io.inc"

extern printf, scanf

section .data
format db '%d', 0x0
flag db 0x0
answer dd 0x1

section .text
foo:
    ;ebx == tmp_register
    ;dword [ebp - 0xC] == tmp_length
    ;eax == answer
    ;dword [ebp - 0x4] == last_element
    ;dword [ebp - 0x8] == new_element
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0xC
        mov dword [ebp - 0xC], 0x1 ;tmp_length == 1
    .loop:
        mov ebx, dword [ebp + 0x8] ;n
        test ebx, ebx
        jz .check_after_loop
        dec dword [ebp + 0x8] ;--n
        .input:
            lea ebx, [ebp - 0x8]
            push ebx
            push format
            call scanf
            add esp, 0x8
        .check_for_start:
            mov bl, byte [flag]
            test bl, byte [flag]
            jz .define_last
            jmp .check_for_increasing
        .define_last:
            mov ebx, dword [ebp - 0x8]
            mov dword [ebp - 0x4], ebx
            mov byte [flag], 0x1
            jmp .loop
        .check_for_increasing:
            mov ebx, dword [ebp - 0x8] 
            cmp dword [ebp - 0x4], ebx
            jge .zeroing
            mov dword [ebp - 0x4], ebx ;retain new element
            inc dword [answer] ;++ans
            jmp .loop
        .zeroing:
            mov dword [ebp - 0x4], ebx ;retain new element
            .check_for_maximum:
                mov ebx, dword [answer]
                cmp ebx, dword [ebp - 0xC]
                jg .retain_better_version
                mov dword [answer], 0x1
                jmp .loop
            .retain_better_version:
                mov ebx, dword [answer]
                mov dword [ebp - 0xC], ebx
                mov dword [answer], 0x1
                jmp .loop
    .check_after_loop:
        mov ebx, dword [answer]
        cmp ebx, dword [ebp - 0xC]
        jg .make_better
        jmp .epilogue
    .make_better:
        mov dword [ebp - 0xC], ebx
    .epilogue:
        mov eax, dword [ebp - 0xC]
        add esp, 0xC
        mov esp, ebp
        pop ebp
        ret

global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4
    .input:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .call_function:
        push dword [ebp - 0x4]
        call foo
        add esp, 0x4
    .output:
        push eax
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        add esp, 0x4
        mov esp, ebp
        pop ebp
        ret