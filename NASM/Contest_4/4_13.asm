%include "io.inc"

CEXTERN fprintf
CEXTERN malloc
CEXTERN free
CEXTERN get_stdout

extern printf, scanf

section .data
format_d db '%d', 0x0
format_dn db '%d', 0xA, 0x0

section .text
apply:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov ebx, 0x0 ; i == 0
    .cycle:
        cmp ebx, dword [ebp + 0xC] ;compare with length
        je .epilogue
        
        mov eax, dword [ebp + 0x8] ;arr pointer
        mov eax, dword [eax + 0x4 * ebx] ;ith element
        
        push eax ;last argument of printf
        
        ;insert arguments into fprintf
        mov ecx, dword [ebp + 0x14] ; i == n
        .insert_cycle:
            cmp ecx, 0x0 ;compare i with 0
            je .call_func
        
            push dword [ebp + 0x14 + 0x4 * ecx] ;push argument
            
            dec ecx ;--i
            jmp .insert_cycle
            
        .call_func:
            call dword [ebp + 0x10] ;call fprintf
            mov eax, dword [ebp + 0x14] ;n
            inc eax ;n + 1
            imul eax, eax, 0x4 ;(n + 1) * 4
            add esp, eax 
            
        inc ebx ;++i
        jmp .cycle
    .epilogue:
        xor eax, eax
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
        sub esp, 0x8 ;for arr pointer and length
    .input_length:
        lea eax, [ebp - 0x8]
        push eax ;length address
        push format_d
        call scanf
        add esp, 0x8
    .allocate_memory:
        mov eax, dword [ebp - 0x8] ;length
        imul eax, eax, 0x4
        sub esp, 0x4
        push eax ;length * sizeof(int)
        call malloc
        add esp, 0x8
        mov dword [ebp - 0x4], eax ;arr pointer
    .input_array:
        mov ebx, 0x0 ; i == 0
        .input_for:
            cmp ebx, dword [ebp - 0x8] ;compare with length
            je .call_function
        
            ;read ith element
            mov eax, dword [ebp - 0x4] ;arr pointer
            lea eax, [eax + 0x4 * ebx] ;address of ith element
            push eax
            push format_d
            call scanf
            add esp, 0x8
        
            inc ebx ;++i
            jmp .input_for
    .call_function:
        push format_dn ;"%d\n"
        call get_stdout
        push eax ;stdout
        push 0x2 ;n
        push fprintf
        push dword [ebp - 0x8] ;length
        push dword [ebp - 0x4] ;arr pointer
        call apply
        add esp, 0x20
    .free_memory:
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret