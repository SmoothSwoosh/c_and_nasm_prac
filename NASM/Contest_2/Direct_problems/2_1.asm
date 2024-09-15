%include "io.inc"

extern printf, scanf

section .data
format db '%d ', 0x0

section .text
find_three_max:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x14
        mov dword [ebp - 0x4], 0x80000000 ;largest max
        mov dword [ebp - 0x8], 0x80000000 ;average max
        mov dword [ebp - 0xC], 0x80000000 ;smallest max
        mov eax, dword [ebp + 0x8]
        mov dword [ebp - 0x10], eax ;n
        mov dword [ebp - 0x14], 0x0 ;new_element
    .loop:
        mov eax, dword [ebp - 0x10]
        test eax, eax
        jz .output
        dec dword [ebp - 0x10]
        .input_element:
            lea eax, [ebp - 0x14]
            push eax
            push format
            call scanf
            add esp, 0x8
        mov eax, dword [ebp - 0x14]
        cmp eax, dword [ebp - 0x4]
        jg .new_bigger_than_largest
        cmp eax, dword [ebp - 0x8]
        jg .new_bigger_than_average
        cmp eax, dword [ebp - 0xC]
        jg .new_bigger_than_smallest
        jmp .loop
        .new_bigger_than_largest:
            mov ebx, dword [ebp - 0x8]
            mov dword [ebp - 0xC], ebx ;smallest == average
            mov ebx, dword [ebp - 0x4]
            mov dword [ebp - 0x8], ebx ;average == largest
            mov ebx, dword [ebp - 0x14]
            mov dword [ebp - 0x4], ebx ;largest == new
            jmp .loop
        .new_bigger_than_average:
            mov ebx, dword [ebp - 0x8]
            mov dword [ebp - 0xC], ebx ;smallest == average
            mov ebx, dword [ebp - 0x14]
            mov dword [ebp - 0x8], ebx ;average == new
            jmp .loop
        .new_bigger_than_smallest:
            mov ebx, dword [ebp - 0x14]
            mov dword [ebp - 0xC], ebx ;smallest == new
            jmp .loop
    .output:
        .print_largest:
            push dword [ebp - 0x4]
            push format
            call printf
            add esp, 0x8
        .print_average:
            push dword [ebp - 0x8]
            push format
            call printf
            add esp, 0x8
        .print_smallest:
            push dword [ebp - 0xC]
            push format
            call printf
            add esp, 0x8
    .epilogue:
        xor eax, eax
        add esp, 0x14
        mov esp, ebp
        pop ebp
        ret

global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4
    .input_n:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .call_function:
        push dword [ebp - 0x4]
        call find_three_max
        add esp, 0x4
    .epilogue:
        xor eax, eax
        add esp, 0x4
        mov esp, ebp
        pop ebp
        ret