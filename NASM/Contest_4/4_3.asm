%include "io.inc"

CEXTERN malloc
CEXTERN free
CEXTERN strlen
CEXTERN strstr
CEXTERN strncpy

extern printf, scanf

section .data
format_in db '%s', 0x0
format_out_0 db '%s', 0x0
format_out_n0 db '%s[%s]%s', 0x0

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x10 ;for a, b, a' and b'
    .get_memory:
        ;for a
        sub esp, 0xC
        push 0x65 ;101
        call malloc
        add esp, 0x10
        mov dword [ebp - 0x4], eax ;a_pointer
        
        ;for b
        sub esp, 0xC
        push 0x65 ;101
        call malloc
        add esp, 0x10
        mov dword [ebp - 0x8], eax ;b_pointer
    .read_strings:
        ;read a
        sub esp, 0x8
        push dword [ebp - 0x4]
        push format_in
        call scanf
        add esp, 0x10
        
        ;read b
        sub esp, 0x8
        push dword [ebp - 0x8]
        push format_in
        call scanf
        add esp, 0x10
    .compare_strings:
        ;does s1 contain s2
        sub esp, 0x8
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call strstr
        add esp, 0x10
        
        cmp eax, 0x0
        jne .just_do_it
        
        ;does s1 contain s2
        sub esp, 0x8
        push dword [ebp - 0x4]
        push dword [ebp - 0x8]
        call strstr
        add esp, 0x10
        
        cmp eax, 0x0 
        je .output_0 
        
        ;exchange two strings 
        mov ecx, dword [ebp - 0x4]
        mov edx, dword [ebp - 0x8]
        xchg ecx, edx
        mov dword [ebp - 0x4], ecx
        mov dword [ebp - 0x8], edx
    .just_do_it:
        ;so now eax contains pointer to the first occurrence
        push eax ;retain pointer
        .take_a_hatch:
            mov ebx, eax
            sub eax, dword [ebp - 0x4] ;occur_pointer - a_pointer (so its len(a'))
            inc eax ;for 0x0 
            
            ;get memory for a'
            push eax ;retain len(a') + 1
            sub esp, 0xC
            push eax ;len(a') + 1
            call malloc
            add esp, 0x10
            mov dword [ebp - 0xC], eax ;a'_pointer
            pop eax ;get len(a') + 1 back into eax
    
            ;take a'
            dec eax
            push eax ;retain len(a')
            sub esp, 0x4
            push eax ;len(a')
            push dword [ebp - 0x4] ;a_pointer
            push dword [ebp - 0xC] ;a'_pointer
            call strncpy
            add esp, 0x10
            pop eax ;get len(a') back into eax
            
            ;a'[len(a') - 1] = 0x0
            mov ebx, dword [ebp - 0xC]
            mov byte [ebx + eax], 0x0
        .take_b_hatch:
            ;take strlen(b)
            sub esp, 0xC
            push dword [ebp - 0x8] ;b_pointer
            call strlen
            add esp, 0x10 ;eax == strlen(b)
            
            pop ebx ;get pointer back into ebx
            add ebx, eax ;pointer + strlen(b)
            
            ;get memory for b'
            push ebx ;retain pointer + strlen(b)           
            sub ebx, dword [ebp - 0x4] ;(pointer + strlen(b)) - a_pointer
            
            ;take strlen(a)
            sub esp, 0xC
            push dword [ebp - 0x4]
            call strlen
            add esp, 0x10 ;eax == strlen(a)
           
            sub eax, ebx ;eax == len(b')
            
            inc eax ;len(b') + 1
            push eax ;retain
            ;allocate memory for b'
            sub esp, 0xC
            push eax
            call malloc
            add esp, 0x10 
            mov dword [ebp - 0x10], eax ;b'_pointer
            pop eax ;get back
            
            pop ebx ;get pointer + strlen(b)
            ;take b'
            dec eax ;len(b')
            push eax ;retain len(b')
            sub esp, 0x4
            push eax
            push ebx
            push dword [ebp - 0x10]
            call strncpy
            add esp, 0x10
            pop eax ;get len(b') back

            ;b'[len(b') - 1] = 0x0
            mov ebx, dword [ebp - 0x10]
            mov byte [ebx + eax], 0x0
            
            jmp .output_n0
    .output_n0:
        push dword [ebp - 0x10]
        push dword [ebp - 0x8]
        push dword [ebp - 0xC]
        push format_out_n0
        call printf
        add esp, 0x10
        jmp .free_memory
    .output_0:
        sub esp, 0x8
        push dword [ebp - 0x4]
        push format_out_0
        call printf
        add esp, 0x10
        
        ;free a
        sub esp, 0xC
        push dword [ebp - 0x4]
        call free
        add esp, 0x10
        ;free b
        sub esp, 0xC
        push dword [ebp - 0x8]
        call free
        add esp, 0x10
        jmp .epilogue
    .free_memory:
        ;free a
        sub esp, 0xC
        push dword [ebp - 0x4]
        call free
        add esp, 0x10
        ;free b
        sub esp, 0xC
        push dword [ebp - 0x8]
        call free
        add esp, 0x10
        ;free a'
        sub esp, 0xC
        push dword [ebp - 0xC]
        call free
        add esp, 0x10
        ;free b'
        sub esp, 0xC
        push dword [ebp - 0x10]
        call free
        add esp, 0x10
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret