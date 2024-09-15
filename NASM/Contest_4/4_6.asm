%include "io.inc"

CEXTERN calloc
CEXTERN free
CEXTERN fopen
CEXTERN fclose
CEXTERN fread
CEXTERN fwrite

extern prinf, scanf

section .data
in_name db 'input.bin', 0x0
in_state db 'rb', 0x0
out_name db 'output.bin', 0x0
out_state db 'wb', 0x0

%define MAXSIZE 0x100000 ;1024 * 1024

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x18 ;for f_in pointer, f_out pointer, address of head, new element, ans, size of array
    .open_files:
        ;f_in
        push in_state
        push in_name
        call fopen
        add esp, 0x8
        mov dword [ebp - 0x4], eax ;f_in pointer
        
        ;f_out
        push out_state
        push out_name
        call fopen
        add esp, 0x8
        mov dword [ebp - 0x8], eax ;f_out pointer
    .allocate_memory_for_array: 
        push 0x4 ;sizeof(int)
        push MAXSIZE
        call calloc
        add esp, 0x8
        mov dword [ebp - 0xC], eax ;arr_pointer
    .input_array:
        mov ebx, 0x0 ;size == 0
        .while_read:
            ;try to read new element
            sub esp, 0x8
            push dword [ebp - 0x4] ;f_in pointer
            push 0x1 ;count
            push 0x4 ;sizeof(int)
            lea eax, [ebp - 0x10]
            push eax ;address for new element
            call fread
            add esp, 0x18
            
            cmp eax, 0x1
            jne .just_do_it
            
            mov eax, dword [ebp - 0x10] ;new element
            mov ecx, dword [ebp - 0xC] ;arr_pointer
            mov dword [ecx + 0x4 * ebx], eax ;arr[i] = new element
            inc ebx ;++size 
            
            jmp .while_read
    .just_do_it:
        mov dword [ebp - 0x18], ebx ;size of array
        ;mov ebx, 0x0 ;i == 0
        ;.out:
        ;    cmp ebx, dword [ebp - 0x18]
        ;    je .after
        ;    
        ;    mov eax, dword [ebp - 0xC]
        ;    PRINT_DEC 4, [eax + 0x4 * ebx]
        ;    NEWLINE
        ;    
        ;    inc ebx
        ;    jmp .out
        ;.after:
        mov dword [ebp - 0x14], 0xFFFFFFFE ;ans = -2
        mov ebx, 0x0 ;i == 0
        .main_for:
            mov eax, ebx ;i
            imul eax, eax, 0x2 ; i * 2
            inc eax ;i * 2 + 1
            mov ecx, eax ;ecx == 2 * i + 1
            
            cmp ecx, dword [ebp - 0x18] ;compare with size
            jge .after_for
            
            mov edx, dword [ebp - 0xC] ;arr_pointer
            mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 1]
            mov eax, dword [ebp - 0xC] ;arr_pointer
            mov eax, dword [eax + 0x4 * ebx] ;arr[i]
            
            cmp eax, edx ;compare arr[i] and arr[2 * i + 1]
            jl .arr_i_lower_arr_2_i_1
            jg .arr_i_greater_arr_2_i_1
            je .arr_i_equal_arr_2_i_1
            
            .arr_i_lower_arr_2_i_1:
                cmp dword [ebp - 0x14], 0xFFFFFFFF ;compare ans with -1
                je .make_ans_zero_and_break
            
                inc ecx ;ecx == 2 * i + 2
                cmp ecx, dword [ebp - 0x18] ;compare 2 * i + 2 with size
                jge .make_ans_one
                
                mov edx, dword [ebp - 0xC] ;arr_pointer
                mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 2]
                mov eax, dword [ebp - 0xC] ;arr_pointer
                mov eax, dword [eax + 0x4 * ebx] ;arr[i]
                
                cmp edx, eax ;compare arr[2 * i + 2] with arr[i]
                jge .make_ans_one
                jmp .make_ans_zero_and_break
            
            .arr_i_greater_arr_2_i_1:
                cmp dword [ebp - 0x14], 0x1 ;compare ans with 1
                je .make_ans_zero_and_break
                
                inc ecx ;ecx == 2 * i + 2
                cmp ecx, dword [ebp - 0x18] ;compare 2 * i + 2 with size
                jge .make_ans_minus_one
                
                mov edx, dword [ebp - 0xC] ;arr_pointer
                mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 2]
                mov eax, dword [ebp - 0xC] ;arr_pointer
                mov eax, dword [eax + 0x4 * ebx] ;arr[i]
                
                cmp edx, eax ;compare arr[2 * i + 2] with arr[i]
                jle .make_ans_minus_one
                jmp .make_ans_zero_and_break
                
            .arr_i_equal_arr_2_i_1:
                mov edi, 0x0 ;flag == false
                .check_1:
                    push ecx ;retain 2 * i + 1
                    cmp dword [ebp - 0x14], 0x1 ;compare ans with 1
                    je .ans_1_or_minus_2
                    cmp dword [ebp - 0x14], 0xFFFFFFFE ;compare ans with -2
                    je .ans_1_or_minus_2
                .check_2:
                    pop ecx ;get 2 * i + 1 back into ecx
                    cmp dword [ebp - 0x14], 0xFFFFFFFE ;compare ans with -2
                    je .ans_minus_2_or_flag
                    ;make ans == -1 and !flag
                    cmp dword [ebp - 0x14], 0xFFFFFFFF ;compare ans with -1
                    jne .check_3
                    cmp edi, 0x0
                    je .ans_minus_2_or_flag
                .check_3:
                    cmp edi, 0x0
                    je .make_ans_zero_and_break
                    inc ebx ;++i
                    jmp .main_for

                .ans_1_or_minus_2:
                    mov edx, dword [ebp - 0xC] ;arr_pointer
                    mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 1]
                    mov eax, dword [ebp - 0xC] ;arr_pointer
                    mov eax, dword [eax + 0x4 * ebx] ;arr[i]
                    
                    cmp eax, edx ;compare arr[i] and arr[2 * i + 1]
                    jg .check_2
                
                    inc ecx ;ecx == 2 * i + 2
                    cmp ecx, dword [ebp - 0x18] ;compare 2 * i + 2 with size
                    jge .make_ans_one_and_true
                    
                    mov edx, dword [ebp - 0xC] ;arr_pointer
                    mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 2]
                    mov eax, dword [ebp - 0xC] ;arr_pointer
                    mov eax, dword [eax + 0x4 * ebx] ;arr[i]
                    
                    cmp edx, eax ;compare arr[2 * i + 2] with arr[i]
                    jge .make_ans_one_and_true
                    jmp .check_2
                
                .ans_minus_2_or_flag:
                    mov edx, dword [ebp - 0xC] ;arr_pointer
                    mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 1]
                    mov eax, dword [ebp - 0xC] ;arr_pointer
                    mov eax, dword [eax + 0x4 * ebx] ;arr[i]
                    
                    cmp eax, edx ;compare arr[i] and arr[2 * i + 1]
                    jl .check_3
                    
                    inc ecx ;ecx == 2 * i + 2
                    cmp ecx, dword [ebp - 0x18] ;compare 2 * i + 2 with size
                    jge .make_ans_minus_one_and_true
                    
                    mov edx, dword [ebp - 0xC] ;arr_pointer
                    mov edx, dword [edx + 0x4 * ecx] ;arr[2 * i + 2]
                    mov eax, dword [ebp - 0xC] ;arr_pointer
                    mov eax, dword [eax + 0x4 * ebx] ;arr[i]
                    
                    cmp edx, eax ;compare arr[2 * i + 2] with arr[i]
                    jle .make_ans_minus_one_and_true
                    jmp .check_3
            
            .make_ans_zero_and_break:
                mov dword [ebp - 0x14], 0x0 ;ans == 0
                jmp .after_for
            .make_ans_minus_one:
                mov dword [ebp - 0x14], 0xFFFFFFFF ;ans == -1
                inc ebx ;++i
                jmp .main_for
            .make_ans_minus_one_and_true:
                mov dword [ebp - 0x14], 0xFFFFFFFF ;ans == -1
                mov edi, 0x1 ;flag == true
                jmp .check_3
            .make_ans_one_and_true:
                mov dword [ebp - 0x14], 0x1 ;ans == 1
                mov edi, 0x1 ;flag == true
                jmp .check_2
            .make_ans_one:
                mov dword [ebp - 0x14], 0x1 ;ans == 1
                inc ebx ;++i
                jmp .main_for
    .after_for:
        cmp dword [ebp - 0x18], 0x1 ;compare size with 1
        jne .output
        mov dword [ebp - 0x14], 0x1 ;ans == 1
    .output:
        sub esp, 0x8
        push dword [ebp - 0x8] ;f_out pointer
        push 0x1 ;count
        push 0x4 ;sizeof(int)
        lea eax, [ebp - 0x14] ;address of ans
        push eax
        call fwrite
        add esp, 0x18
    .close_files:
        ;f_in
        sub esp, 0x4
        push dword [ebp - 0x4] ;f_in pointer
        call fclose
        add esp, 0x8
        
        ;f_out
        sub esp, 0x4
        push dword [ebp - 0x8] ;f_out pointer
        call fclose
        add esp, 0x8
    .free_memory:
        sub esp, 0x4
        push dword [ebp - 0xC] ;address of head of array
        call free
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret