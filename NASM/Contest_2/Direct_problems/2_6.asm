%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0

section .text
search:
    ;eax == tmp_register
    ;dword [ebp - 0x4] == tmp_ans
    ;dword [ebp - 0x8] == number_of_times (32 - k)
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x8
        mov dword [ebp - 0x4], 0x0
    .get_times:
        mov eax, 0x21 ;eax == 33
        sub eax, dword [ebp + 0xC] ;eax == 32 - k
        mov dword [ebp - 0x8], eax ;retaining number
    .loop:
        .is_it_stop:
            mov eax, dword [ebp - 0x8]
            test eax, eax
            jz .epilogue ;if number_of_times == 0
            dec dword [ebp - 0x8]
        .get_k_ones:
            mov eax, 0x1
            mov ecx, dword [ebp + 0xC]
            shl eax, cl
            sub eax, 0x1 ;eax == 1...1(k times)
        .get_k_bits:
            mov ebx, dword [ebp + 0x8] ;n
            and ebx, eax ;n & 1...1(k times)
        .compare:
            cmp ebx, dword [ebp - 0x4] 
            jg .make_better
            jmp .preprocessing
        .make_better:
            mov dword [ebp - 0x4], ebx
        .preprocessing:
            shr dword [ebp + 0x8], 0x1 ;n >> 1
        jmp .loop
     .epilogue:
        mov eax, dword [ebp - 0x4]
        add esp, 0x8
        mov esp, ebp
        pop ebp
        ret
        

global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x8
    .input_n:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    .input_k:
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8    
    .call_function:
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call search
        add esp, 0x8
    .output:
        push eax
        push format
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        add esp, 0x8
        mov esp, ebp
        pop ebp
        ret