%include "io.inc"

extern printf, scanf

%define size 0x200000

section .data
format db '%s', 0x0

section .text
compar:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x10 ;for a/b and c/d
        push ebx
        push ecx 
    .compare_fractions:
        mov ecx, dword [ebp + 0x8] ;take first address
        mov eax, dword [ecx]
        mov dword [ebp - 0x4], eax ;a
        ;PRINT_UDEC 4, eax
        ;NEWLINE
        
        mov eax, dword [ecx + 0x4]
        mov dword [ebp - 0x8], eax ;b
        
        mov ecx, dword [ebp + 0xC] ;take second address
        mov eax, dword [ecx]
        mov dword [ebp - 0xC], eax ;c
        
        mov eax, dword [ecx + 0x4]
        mov dword [ebp - 0x10], eax ;d
        
        ;lets make a * d
        xor edx, edx
        mov eax, dword [ebp - 0x4] ;a
        mul dword [ebp - 0x10] ;a * d
        push eax 
        push edx
        
        ;PRINT_UDEC 4, [ebp - 0xC]
        ;PRINT_CHAR ' '
        ;PRINT_UDEC 4, [ebp - 0x10]
        ;NEWLINE
        xor edx, edx
        mov eax, dword [ebp - 0xC] ;c
        mul dword [ebp - 0x8] ;c * b
        pop ecx ;prev edx
        pop ebx ;prev eax
        
        cmp ecx, edx ;compare first_h and second_h
        jb .make_ans_minus_one
        ja .make_ans_one
        
        cmp ebx, eax ;compare first_l and second_l
        jb .make_ans_minus_one
        ja .make_ans_one
        
        ;so now fractions are equal
        mov eax, dword [ebp - 0x4]
        cmp eax, dword [ebp - 0xC] ;compare a with c
        jb .make_ans_minus_one
        ja .make_ans_one
        je .make_ans_zero
    .make_ans_one:
        mov eax, 0x1 ;so first > second
        jmp .epilogue 
    .make_ans_minus_one:
        mov eax, 0xFFFFFFFF ;so first < second
        jmp .epilogue
    .make_ans_zero:
        mov eax, 0x0 ;so first == second
        jmp .epilogue
    .epilogue:
        pop ecx
        pop ebx
        mov esp, ebp
        pop ebp
        ret

qRecursiveSort:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x10 ;for i, j, mid_a and mid_b
        push ebx
        push ecx
    mov eax, dword [ebp + 0xC] ;take size of array
    mov dword [ebp - 0x4], 0x0 ;i == 0
    mov dword [ebp - 0x8], eax 
    sub dword [ebp - 0x8], 0x2 ;j == count - 1
    xor edx, edx
    mov ecx, 0x2
    div ecx ;eax == div (size/2)
    
    .check:
        mov ebx, eax ;retain div (size/2)
        xor edx, edx
        mov ecx, 0x2
        div ecx ;edx == mod(size/2)
        cmp edx, 0x0
        je .after_check
        dec ebx
    
    .after_check:
        mov eax, ebx
        mov ecx, dword [ebp + 0x8] ;take address of address of head
        mov edx, dword [ecx + 0x4 * eax] ;take mid_a
        mov dword [ebp - 0x10], edx
        mov edx, dword [ecx + 0x4 * eax + 0x4] ;take mid_b
        mov dword [ebp - 0xC], edx
    
        ;now lets organize do-while cycle
        .do_while:  
            .while_i:
                mov ebx, dword [ebp - 0x4] ;i
                sub esp, 0x8
                lea eax, [ebp - 0x10]
                push eax ;address of arr[size/2]
                lea eax, [ecx + 0x4 * ebx]
                push eax ;address of arr[i]
                call dword [ebp + 0x10]
                add esp, 0x10
                
                cmp eax, 0xFFFFFFFF 
                jne .while_j
                
                add dword [ebp - 0x4], 0x2 ;++i
                jmp .while_i
                
            .while_j:
                mov ebx, dword [ebp - 0x8] ;j
                sub esp, 0x8
                lea eax, [ebp - 0x10]
                push eax ;address of arr[size/2]
                lea eax, [ecx + 0x4 * ebx]
                push eax ;address of arr[j]
                call dword [ebp + 0x10] ;call compar
                add esp, 0x10
                
                cmp eax, 0x1 
                jne .compare_i_and_j
                
                sub dword [ebp - 0x8], 0x2 ;--j
                jmp .while_j
                
            .compare_i_and_j:
                mov ebx, dword [ebp - 0x4] ;i
                cmp ebx, dword [ebp - 0x8] ;compare with j
                jle .make_swap
                jmp .after_do_while
                .make_swap:
                    ;exchange numerators
                    mov ebx, dword [ebp - 0x4] ;i
                    mov edx, dword [ecx + 0x4 * ebx] ;arr[i].first
                    mov ebx, dword [ebp - 0x8] ;j
                    mov eax, dword [ecx + 0x4 * ebx] ;arr[j].first
                    
                    xchg eax, edx ;exhange
                    mov ebx, dword [ebp - 0x8] ;j
                    mov dword [ecx + 0x4 * ebx], eax
                    mov ebx, dword [ebp - 0x4] ;i
                    mov dword [ecx + 0x4 * ebx], edx
    
                    inc dword [ebp - 0x4] ;++i
                    inc dword [ebp - 0x8] ;++j
                    
                    ;exchange denumerators
                    mov ebx, dword [ebp - 0x4] ;i
                    mov edx, dword [ecx + 0x4 * ebx] ;arr[i].second
                    mov ebx, dword [ebp - 0x8] ;j
                    mov eax, dword [ecx + 0x4 * ebx] ;arr[j].second
                    
                    xchg eax, edx ;exhange
                    mov ebx, dword [ebp - 0x8] ;j
                    mov dword [ecx + 0x4 * ebx], eax
                    mov ebx, dword [ebp - 0x4] ;i
                    mov dword [ecx + 0x4 * ebx], edx
                    
                    inc dword [ebp - 0x4] ;++i
                    sub dword [ebp - 0x8], 0x3 ;--j
                    
                mov ebx, dword [ebp - 0x4] ;i
                cmp ebx, dword [ebp - 0x8] ;compare with j
                jg .after_do_while
                     
            jmp .do_while
        .after_do_while:
            cmp dword [ebp - 0x8], 0x0 ;if j > 0
            jg .recurse_j
            
            .check_recurse_i:
                mov eax, dword [ebp - 0x4] ;i
                cmp eax, dword [ebp + 0xC] ;if i < size
                jl .recurse_i
                
                jmp .epilogue
            
            .recurse_j:
                sub esp, 0x4
                push dword [ebp + 0x10] ;compar
                add dword [ebp - 0x8], 0x2
                push dword [ebp - 0x8] ;j + 1
                push ecx ;address of head
                call qRecursiveSort
                add esp, 0x10
                jmp .check_recurse_i
            
            .recurse_i:
                sub esp, 0x4
                push dword [ebp + 0x10] ;compar
                mov eax, dword [ebp + 0xC] ;size
                sub eax, dword [ebp - 0x4] ;size - i
                push eax ;size - i
                mov ebx, dword [ebp - 0x4] ;i
                lea eax, [ecx + 0x4 * ebx]
                push eax ;address of arr[i]
                call qRecursiveSort
                add esp, 0x10
                
                jmp .epilogue
            
        .epilogue:
            pop ecx
            pop ebx
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
        sub esp, size
    .input_string:
        sub esp, 0x8
        lea eax, [ebp - size]
        push eax
        push format
        call scanf
        add esp, 0x10
    .check_for_point:
        cmp byte [ebp - size], 0x2E ;compare with .
        jne .find_size_of_array ;if string contains only .
        jmp .epilogue
    .find_size_of_array:
        mov eax, 0x0 ;count == 0
        mov ebx, 0x0 ;i == 0
        .find_for:
            cmp byte [ebp - size + ebx], 0x0
            je .make_array
            
            cmp byte [ebp - size + ebx], 0x2C ;compare with ,
            jne .next_iteration            
            inc eax ;++count
            
            .next_iteration:
                inc ebx ;++i 
            jmp .find_for
    .make_array:
        inc eax ;++count
        ;take memory for array of fractions
        mov ebx, eax 
        mov ecx, 0x10
        mul ecx
        sub esp, eax
        mov eax, ebx

        mov ebx, 0x0 ;j == 0
        mov ecx, 0xFFFFFFFF ;i == -1
        .make_for:
            cmp ecx, 0xFFFFFFFF
            je .make_element
            
            cmp byte [ebp - size + ecx], 0x2C ;compare with ,
            je .make_element
            
            cmp byte [ebp - size + ecx], 0x0 
            je .sort_array
            
            inc ecx ;++i
            jmp .make_for
            
            .make_element:
                push eax
                push ebx
                ;take a/b
                mov dword [ebp - 0x4], 0x0 ;a == 0
                mov dword [ebp - 0x8], 0x1 ;b == 1
                inc ecx ;++i
                .make_a:
                    cmp byte [ebp - size + ecx], 0x2C ;compare with ,
                    je .after_make_a
                    
                    cmp byte [ebp - size + ecx], 0x2E ;compare with .
                    je .after_make_a
                    
                    cmp byte [ebp - size + ecx], 0x2F ;compare with /
                    je .after_make_a
                    
                    mov eax, dword [ebp - 0x4]
                    mov edx, 0xA ;10
                    mul edx ;a *= 10
                    xor edx, edx
                    movzx edx, byte [ebp - size + ecx]
                    sub edx, 0x30 ;digit -= '0'
                    add eax, edx 
                    mov dword [ebp - 0x4], eax ;a * 10 + digit
                    
                    inc ecx ;++i
                    
                    jmp .make_a
                .after_make_a:
                    ;so now we have a
                    cmp byte [ebp - size + ecx], 0x2F ;compare with /
                    jne .add_new_element
                    
                    inc ecx ;++i
                    mov dword [ebp - 0x8], 0x0 ;b == 0
                    .make_b:
                        cmp byte [ebp - size + ecx], 0x2E ;compare with .
                        je .add_new_element
                        
                        cmp byte [ebp - size + ecx], 0x2C ;compare with ,
                        je .add_new_element
                        
                        mov eax, dword [ebp - 0x8]
                        mov edx, 0xA ;10
                        mul edx ;b * 10
                        xor edx, edx
                        movzx edx, byte [ebp - size + ecx]
                        sub edx, 0x30 ;digit -= '0'
                        add eax, edx 
                        mov dword [ebp - 0x8], eax ;b * 10 + digit
                        
                        inc ecx ;++i
                        jmp .make_b
            .add_new_element:
                pop ebx ;get j back into ebx
                
                mov eax, dword [ebp - 0x4]
                mov dword [esp + 0x4 * ebx + 0x4], eax ;add a
                inc ebx ;++j
                mov eax, dword [ebp - 0x8]
                mov dword [esp + 0x4 * ebx + 0x4], eax ;add b
                inc ebx ;++j 

                pop eax ;get size back into eax
            jmp .make_for
    .sort_array:
        ;mov ebx, 0x0 ;i == 0
        ;.ttt:
        ;    cmp ebx, eax 
        ;    je .after
        ;    
        ;    PRINT_UDEC 4, [esp + 0x4 * ebx]
        ;    NEWLINE
        ;    
        ;    inc ebx ;++i
        ;    jmp .ttt
        ;.after:
        ;call qsort
        sub esp, 0x4
        push compar ;comparator
        mov ecx, 0x2 
        mul ecx 
        mov ebx, eax ;size
        push ebx ;size of array
        lea eax, [esp + 0xC] 
        push eax ;address for head of array
        call qRecursiveSort
        add esp, 0x10
    .output:
        mov eax, ebx ;size * 2 of array
        
        mov ebx, 0x0 ;i == 0
        .out_for:
            cmp ebx, eax
            je .epilogue
            
            PRINT_UDEC 4, [esp + 0x4 * ebx]
            inc ebx ;++i
            cmp dword [esp + 0x4 * ebx], 0x1 
            jne .out_denumerator
            
            inc ebx ;++i
            cmp ebx, eax
            je .epilogue
            PRINT_CHAR ',' 
            jmp .out_for
            
            .out_denumerator:
                PRINT_CHAR '/'
                PRINT_UDEC 4, [esp + 0x4 * ebx]   
                inc ebx ;++i
                cmp ebx, eax
                je .epilogue
                PRINT_CHAR ',' 
            jmp .out_for
    .epilogue:
        PRINT_CHAR '.'
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret