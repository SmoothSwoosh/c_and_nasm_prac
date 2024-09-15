%include "io.inc"

CEXTERN malloc
CEXTERN strcmp
CEXTERN free

extern printf, scanf

section .data
format_d db '%d', 0x0
format_s db '%s', 0x0

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x10 ;for n, head of array, flag and ans
    .input_n:
        sub esp, 0x8
        lea eax, [ebp - 0x4]
        push eax
        push format_d
        call scanf
        add esp, 0x10
    .get_memory:
        sub esp, 0xC
        push 0x1770 ;for 6000 bytes
        call malloc
        add esp, 0x10 ;address of head of array into eax
        mov dword [ebp - 0x8], eax ;address of head of array
    .input_array_of_strings:   
        mov ebx, 0x0 ;i == 0
        .input_for:
            cmp ebx, dword [ebp - 0x4] ;compare with n
            je .just_do_it
            
            ;prepair to read new string
            mov eax, dword [ebp - 0x8] ;address of head
            push ebx ;retain i
            imul ebx, ebx, 0xB ;i * 11
            lea ecx, [eax + ebx] ;position of ith string in array
            pop ebx ;get i back into ebx
            
            ;read new string
            sub esp, 0x8
            push ecx
            push format_s
            call scanf
            add esp, 0x10
            
            inc ebx ;++i
            jmp .input_for
    .just_do_it:
        mov ebx, 0x0 ;i == 0
        mov dword [ebp - 0x10], 0x0 ;ans == 0
        .i_loop:   
            cmp ebx, dword [ebp - 0x4] ;compare with n
            jge .output_ans
            
            mov dword [ebp - 0xC], 0x0 ;flag(is not unique) == false
            mov ecx, ebx 
            inc ecx ;j == i + 1
            .j_loop:
                cmp ecx, dword [ebp - 0x4] ;compare with n
                jge .after_j_loop
                ;prepair to compare 
                mov eax, dword [ebp - 0x8] ;address of head
                push ecx ;retain j
                push ebx ;retain i
                imul ecx, ecx, 0xB ;j * 11
                imul ebx, ebx, 0xB ;i * 11
                
                ;compare strings arr[i] and arr[j]
                sub esp, 0x8
                lea edx, [eax + ecx] ;address of arr[j]
                push edx 
                lea edx, [eax + ebx] ;address of arr[i]
                push edx
                call strcmp
                add esp, 0x10 
                
                pop ebx ;get i back
                pop ecx ;get j back
                
                cmp eax, 0x0
                jne .next_j_iteration ;if arr[i] != arr[j]
                mov dword [ebp - 0xC], 0x1 ;flag == True
                jmp .after_j_loop
                
                .next_j_iteration:
                    inc ecx ;++j
                jmp .j_loop
                
            .after_j_loop:
                cmp dword [ebp - 0xC], 0x0
                jne .next_i_iteration
                inc dword [ebp - 0x10] ;++ans
                
                .next_i_iteration:
                    inc ebx ;++i
                jmp .i_loop
    .output_ans:
        sub esp, 0x8
        push dword [ebp - 0x10]
        push format_d
        call printf
        add esp, 0x10
    .free_memory:
        sub esp, 0xC
        push dword [ebp - 0x8]
        call free
        add esp, 0x10
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret