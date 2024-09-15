%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0

section .text
number_of_zeros:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4 ;for 2^m (mask)
        push ebx
    mov eax, 0x0 ;ans == 0
    mov dword [ebp - 0x4], 0x1 ;2^0
    .loop:
        mov ebx, dword [ebp - 0x4]
        cmp ebx, dword [ebp + 0x8]
        jge .epilogue
        and ebx, dword [ebp + 0x8]
        cmp ebx, 0x0
        jne .prepair_for_next_it
        inc eax ;++count
        .prepair_for_next_it:   
            shl dword [ebp - 0x4], 0x1 ;2^t -> 2^(t + 1)
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
    .input_n:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .allocate_memory_for_array:
        mov eax, dword [ebp - 0x4]
        mov ecx, 0x4
        mul ecx
        sub esp, eax ;so esp is base for array
    mov ebx, 0x0 ;i == 0
    .input_array:
        cmp ebx, dword [ebp - 0x4]
        jge .input_k
        
        ;input new element
        lea eax, [esp + 0x4 * ebx]
        push eax
        push format
        call scanf
        add esp, 0x8
        
        inc ebx ;++i
        jmp .input_array
    .input_k:
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8
    mov ebx, 0x0 ;i == 0
    mov eax, 0x0 ;ans == 0
    .loop:
        cmp ebx, dword [ebp - 0x4]
        jge .output
        mov ecx, dword [esp + 0x4 * ebx]
        push ebx ;retain i
        mov ebx, eax ;retain ans
        
        ;call function of number of zeros
        sub esp, 0x4
        push ecx
        call number_of_zeros
        add esp, 0x8 ;eax == number
        
        cmp eax, dword [ebp - 0x8]
        jne .prepair_for_next_it
        inc ebx 
        
        .prepair_for_next_it:
            mov eax, ebx ;ans
            pop ebx
            inc ebx ;++i
        jmp .loop
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