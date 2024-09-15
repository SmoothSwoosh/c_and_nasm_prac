%include "io.inc"

CEXTERN fopen
CEXTERN fclose
CEXTERN fscanf
CEXTERN fprintf
CEXTERN malloc
CEXTERN qsort
CEXTERN free

extern printf, scanf

section .data
format_d db '%d ', 0x0
in_name db 'input.txt', 0x0
out_name db 'output.txt', 0x0
in_state db 'r', 0x0
out_state db 'w', 0x0

section .text
compar:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .take_elements:
        mov eax, dword [ebp + 0x8] ;take first address
        mov eax, dword [eax] ;take first value
        
        mov ebx, dword [ebp + 0xC] ;take second address
        mov ebx, dword [ebx] ;take second value
        
    .compare_elements:
        cmp eax, ebx 
        jg .make_ans_one
        jl .make_ans_minus_one
        je .make_ans_zero
    .make_ans_one:
        mov eax, 0x1 
        jmp .epilogue
    .make_ans_minus_one:
        mov eax, 0xFFFFFFFF
        jmp .epilogue
    .make_ans_zero:
        mov eax, 0x0
        jmp .epilogue        
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
        sub esp, 0xC ;for file pointer f_in, file pointer f_out and address of head
    .open_files:
        sub esp, 0xC
        push in_state
        push in_name
        call fopen
        add esp, 0x14
        mov dword [ebp - 0x4], eax ;file pointer f_in
        
        sub esp, 0xC
        push out_state
        push out_name
        call fopen
        add esp, 0x14
        mov dword [ebp - 0xC], eax ;file pointer f_out
    .get_memory_for_array:  
        push 0xFA0 ;for 1000 elements
        call malloc
        add esp, 0x4
        mov dword [ebp - 0x8], eax ;address of head
    .input_array:
        mov ebx, 0x0 ;size == 0
        .input_for:
            ;try to read new element
            sub esp, 0x8
            mov ecx, dword [ebp - 0x8] ;address of head
            lea eax, [ecx + 0x4 * ebx]
            push eax
            push format_d
            push dword [ebp - 0x4] ;file pointer
            call fscanf
            add esp, 0x14
            
            cmp eax, 0xFFFFFFFF
            je .sort_array ;if we didnt read anything
            inc ebx ;++count
            
            jmp .input_for
    .sort_array:   
        sub esp, 0x4
        push compar ;comparator
        push 0x4 ;sizeof(int)
        push ebx ;size of array
        push dword [ebp - 0x8] ;address of head
        call qsort
        add esp, 0x14
    .output_array:
        mov ecx, ebx ;size of array
        mov ebx, 0x0 ;i == 0
        .output_for:
            cmp ebx, ecx 
            je .close_files
            
            push ecx ;retain size
            ;output element
            sub esp, 0x8
            mov eax, dword [ebp - 0x8] ;address of head
            push dword [eax + 0x4 * ebx] ;ith element
            push format_d
            push dword [ebp - 0xC] ;file pointer f_out
            call fprintf
            add esp, 0x14
            pop ecx ;get size back into ecx
            
            inc ebx ;++i
            jmp .output_for
    .close_files:
        ;close f_in
        push dword [ebp - 0x4] ;file pointer f_in
        call fclose
        add esp, 0x4
        
        ;close f_out
        push dword [ebp - 0xC] ;file pointer f_out
        call fclose
        add esp, 0x4
    .free_memory:
        push dword [ebp - 0x8] 
        call free
        add esp, 0x4
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret