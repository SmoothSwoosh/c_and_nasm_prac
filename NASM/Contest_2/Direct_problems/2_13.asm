%include "io.inc"

extern printf, scanf

section .data
format db '%u ', 0x0

%define base 0x4C4B40 ;base for array

section .text
long_ror:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, base
        sub esp, 0x10
    .input_array:
        mov ebx, 0x0 ;i == 0
        .loop_in:
            cmp ebx, dword [ebp + 0x8] ;compare with n
            jge .input_k
            
            ;input new element
            sub esp, 0x8
            lea eax, [ebp + 0x4 * ebx - base]
            push eax
            push format
            call scanf
            add esp, 0x10
            inc ebx ;++i
            jmp .loop_in
    .input_k:
        ;k
        sub esp, 0xC
        lea eax, [ebp - 0x10] 
        push eax
        push format
        call scanf
        add esp, 0x10     
    .after_input:
        mov ebx, 0x0 ;i == 0 
        mov dword [ebp - 0xC], 0x0 ;k least bits of previous element  
        .loop:
            cmp ebx, dword [ebp + 0x8] ;compare with n
            jge .output
            
            ;for 1...1 k times
            mov dword [ebp - 0x4], 0x1
            mov cl, byte [ebp - 0x10]
            shl dword [ebp - 0x4], cl
            dec dword [ebp - 0x4] ;here 1...1 k times
            
            mov eax, dword [ebp - 0x4]
            and eax, dword [ebp + 0x4 * ebx - base] 
            mov dword [ebp - 0x8], eax ;k least bits of current element
            
            shr dword [ebp + 0x4 * ebx - base], cl ;current_element >> k
            mov eax, dword [ebp - 0xC]
            neg cl
            add cl, 0x20 ;cl == 32 - k
            shl eax, cl
            or dword [ebp + 0x4 * ebx - base], eax
            
            mov eax, dword [ebp - 0x8]
            mov dword [ebp - 0xC], eax ;retain k least bits of current element as previous
            
            inc ebx ;++i
            jmp .loop
    .output:
        .make_first_element:
            mov cl, byte [ebp - 0x10]
            neg cl
            add cl, 0x20 ;cl == 32 - k
            
            mov eax, dword [ebp - 0xC]
            shl eax, cl
            or dword [ebp - base], eax
        mov ebx, 0x0 ;i == 0
        .loop_out:
            cmp ebx, dword [ebp + 0x8] ;compare with n
            jge .epilogue
            sub esp, 0x8
            push dword [ebp + 0x4 * ebx - base]
            push format
            call printf
            add esp, 0x10
            inc ebx ;++i
            jmp .loop_out
    .epilogue:
        xor eax, eax
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
        sub esp, 0x4
    .input:
        ;n
        sub esp, 0x4
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0xC
    .call_function:
        sub esp, 0x8
        push dword [ebp - 0x4]
        call long_ror
        add esp, 0xC
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret