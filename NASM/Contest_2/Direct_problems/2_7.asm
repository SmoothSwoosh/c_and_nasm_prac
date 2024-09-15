%include "io.inc"

extern printf, scanf

section .data
format db '%d ', 0x0 

%define base 0x9C40 ;40000 == max_size_of_array
%define moved_base 0x9C44 ;40004 for arr[j - 1]

section .text
bogosort:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, base
    mov ebx, 0x0 ;i == 0
    .input_array:
        cmp ebx, dword [ebp + 0x8]
        jl .read_and_inc
        jmp .after_input_array
        .read_and_inc:
            lea eax, [ebp + 0x4 * ebx - base]
            push eax
            push format
            call scanf
            add esp, 0x8
            inc ebx ;++i
            jmp .input_array ;next iteration
    .after_input_array:
        cmp dword [ebp + 0x8], 0x1
        jle .after_loop
        mov ecx, 0x0 ;i == 0; 0 <= i < size_of_array
        mov ebx, 0x1 ;j == 1; 1 <= j < size_of_array
        .for_i:
            mov ebx, 0x1 ;j == 1
            cmp ecx, dword [ebp + 0x8]
            jl .prepair_for_j
            jmp .after_loop
            .prepair_for_j:                
                cmp ebx, dword [ebp + 0x8]
                jl .for_j
                inc ecx ;++i
                jmp .for_i
                .for_j:
                    xor eax, eax
                    mov eax, dword [ebp + 0x4 * ebx - base] ;arr[j]
                    cmp eax, dword [ebp + 0x4 * ebx - moved_base] ;arr[j - 1]
                    jl .exchange
                    inc ebx ;++j
                    jmp .prepair_for_j ;next_iteration
                    .exchange:
                        ;exchange arr[j + 1] and arr[j]
                        xor edx, edx
                        mov edx, dword [ebp + 0x4 * ebx - moved_base]
                        mov dword [ebp + 0x4 * ebx - base], edx
                        mov dword [ebp + 0x4 * ebx - moved_base], eax
                        inc ebx ;++j
                        jmp .prepair_for_j ;next iteration
    .after_loop:  
        mov ebx, 0x0 ;i == 0
        .output_array:
            cmp ebx, dword [ebp + 0x8]
            jl .print_and_inc
            jmp .epilogue
            .print_and_inc:
                push dword [ebp + 0x4 * ebx - base]
                push format
                call printf
                add esp, 0x8
                inc ebx ;++i
                jmp .output_array
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
    .input_n:
        lea eax, [ebp - 0x4]
        sub esp, 0x4
        push eax 
        push format
        call scanf
        add esp, 0xC
    .call_function:
        sub esp, 0x8
        push dword [ebp - 0x4]
        call bogosort
        add esp, 0xC
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret