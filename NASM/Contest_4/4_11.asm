%include "io.inc"

CEXTERN malloc
CEXTERN free
CEXTERN fopen
CEXTERN fclose
CEXTERN fscanf
CEXTERN fprintf

section .data
format db '%d ', 0x0
in_name db 'input.txt', 0x0
in_state db 'r', 0x0
out_name db 'output.txt', 0x0
out_state db 'w', 0x0

section .bss
last resd 1 ;last pointer

section .text
init:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .allocate_memory:
        ;for root        
        sub esp, 0xC
        push 0xC ;for value, next and rear
        call malloc
        add esp, 0x10 ;eax == root pointer
        mov ebx, eax
        ;for last        
        sub esp, 0xC
        push 0xC ;for value, next and rear
        call malloc
        add esp, 0x10 
        mov dword [last], eax ;last pointer
        
        mov dword [eax], 0x0 ;last->value = 0
        mov dword [eax + 0x4], 0x0 ;last->next = 0
        mov dword [eax + 0x8], 0x0 ;last->rear = 0
        
        mov dword [ebx], 0x0 ;root->value = 0
        mov dword [ebx + 0x4], 0x0 ;root->next = 0
        mov dword [ebx + 0x8], 0x0 ;root->reat = 0
        
        mov eax, ebx ;eax == root pointer
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
insert:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .insert_new_value:
        mov eax, dword [ebp + 0xC] ;cur = root
        .check_is_empty:
            mov ebx, dword [last] ;last pointer
            cmp dword [ebx], 0x0 ;compare last->value with 0
            je .after_check
            mov eax, dword [last] ;cur = last 
        .after_check:
            mov ebx, dword [ebp + 0x10]
            mov dword [eax + 0x4], ebx ;cur->next = x
            
            mov ebx, dword [ebp + 0x8] ;arr pointer
            mov ecx, dword [ebp + 0x10] ;x
            mov ebx, dword [ebx + 0x4 * ecx] ;arr[x]
            mov dword [ebx + 0x4], 0x0 ;arr[x]->next = 0
            mov ecx, dword [eax] ;cur->value
            mov dword [ebx + 0x8], ecx ;arr[x]->rear = cur->value
            mov ecx, dword [ebp + 0x10] ;x
            mov dword [ebx], ecx ;arr[x]->value = x  

            mov dword [last], ebx ;last = arr[x]
    .epilogue:
        xor eax, eax
        pop ebx
        mov esp, ebp
        pop ebp
        ret

swap:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .make_swap:
        ;now a means arr[a], b means arr[b]
        
        ;make arr[a->rear]->next = b->next
        mov ecx, dword [ebp + 0x10] ;a pointer
        mov ecx, dword [ecx + 0x8] ;a->rear
        mov eax, dword [ebp + 0x8] ;arr pointer
        mov eax, dword [eax + 0x4 * ecx] ;arr[a->rear]
        mov ecx, dword [ebp + 0x14] ;b pointer
        mov ecx, dword [ecx + 0x4] ;b->next
        mov dword [eax + 0x4], ecx ;arr[a->rear]->next = b->next
        
        ;make arr[b->next]->rear = a->rear
        mov ecx, dword [ebp + 0x14] ;b pointer
        mov ecx, dword [ecx + 0x4] ;b->next
        mov eax, dword [ebp + 0x8] ;arr pointer
        mov eax, dword [eax + 0x4 * ecx] ;arr[b->next]
        mov ecx, dword [ebp + 0x10] ;a pointer
        mov ecx, dword [ecx + 0x8] ;a->rear
        mov dword [eax + 0x8], ecx ;arr[b->next]->rear = a->rear
        
        ;make arr[root->next]->rear = b->value
        mov ecx, dword [ebp + 0xC] ;root pointer
        mov ecx, dword [ecx + 0x4] ;root->next
        mov eax, dword [ebp + 0x8] ;arr pointer
        mov eax, dword [eax + 0x4 * ecx] ;arr[root->next]
        mov ecx, dword [ebp + 0x14] ;b pointer
        mov ecx, dword [ecx] ;b->value
        mov dword [eax + 0x8], ecx ;arr[root->next]->rear = b->value
        
        ;make b->next = root->next
        mov ecx, dword [ebp + 0x14] ;b pointer
        mov eax, dword [ebp + 0xC] ;root pointer
        mov eax, dword [eax + 0x4] ;root->next
        mov dword [ecx + 0x4], eax ;b->next = root->next
        
        ;make a->rear = 0
        mov eax, dword [ebp + 0x10] ;a pointer
        mov dword [eax + 0x8], 0x0 ;a->rear = 0
        
        ;make root->next = a->value
        mov ecx, dword [ebp + 0xC] ;root pointer
        mov eax, dword [ebp + 0x10] ;a pointer
        mov eax, dword [eax] ;a->value
        mov dword [ecx + 0x4], eax ;root->next = a->value
    .epilogue:
        xor eax, eax
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
destruct:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    ;free root
    sub esp, 0xC
    push dword [ebp + 0xC] ;root pointer
    call free
    add esp, 0x10
    ;free arr
    mov ebx, 0x1 ;i == 1
    .free_for:
        cmp ebx, dword [ebp + 0x10] ;compare with n
        jg .epilogue
        
        mov eax, dword [ebp + 0x8] ;arr pointer
        ;free arr[i]
        sub esp, 0xC
        push dword [eax + 0x4 * ebx]
        call free
        add esp, 0x10
        
        inc ebx ;++i
        jmp .free_for
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
        sub esp, 0x20 ;for f_in pointer, f_out pointer, n, m, root pointer, arr pointer, a, b
    .open_files:
        ;f_in
        sub esp, 0x8
        push in_state
        push in_name
        call fopen
        add esp, 0x10
        mov dword [ebp - 0x4], eax ;f_in pointer
        
        ;f_out
        sub esp, 0x8
        push out_state
        push out_name
        call fopen
        add esp, 0x10
        mov dword [ebp - 0x8], eax ;f_out pointer
    .input_n_and_m:
        ;n
        sub esp, 0x4
        lea eax, [ebp - 0xC]
        push eax
        push format
        push dword [ebp - 0x4] ;f_in pointer
        call fscanf
        add esp, 0x10
        
        ;m
        sub esp, 0x4
        lea eax, [ebp - 0x10]
        push eax
        push format
        push dword [ebp - 0x4] ;f_out pointer
        call fscanf
        add esp, 0x10
    .init_list:
        call init
        mov dword [ebp - 0x14], eax ;root pointer
    .get_memory_for_array:
        mov eax, dword [ebp - 0xC]
        inc eax
        imul eax, eax, 0x4
        sub esp, 0xC
        push eax ;n + 1
        call malloc
        add esp, 0x10
        mov dword [ebp - 0x18], eax ;arr pointer
    .arr_0_equals_root:
        mov eax, dword [ebp - 0x18] ;arr pointer
        mov ecx, dword [ebp - 0x14] ;root pointer
        mov dword [eax], ecx ;arr[0] = root pointer
    .get_memory_for_structures:
        mov ebx, 0x1 ;i == 1
        .get_for:
            cmp ebx, dword [ebp - 0xC] ;compare with n
            jg .fill_array
            
            ;take memory for new element
            sub esp, 0xC
            push 0xC ;for value, next and rear
            call malloc
            add esp, 0x10 ;eax == element pointer
            
            mov ecx, dword [ebp - 0x18] ;arr pointer
            mov dword [ecx + 0x4 * ebx], eax ;arr[i] = element pointer 
            
            inc ebx ;++i
            jmp .get_for
    .fill_array:
        mov ebx, 0x1 ;i == 1
        .input_for:
            cmp ebx, dword [ebp - 0xC] ;compare with n
            jg .make_stuff
        
            ;insert i
            sub esp, 0x4
            push ebx ;x
            push dword [ebp - 0x14] ;root pointer
            push dword [ebp - 0x18] ;arr pointer
            call insert
            add esp, 0x10

            inc ebx ;++i
            jmp .input_for
    .make_stuff: 
        mov ebx, 0x0 ;i == 0
        .stuff_for:
            cmp ebx, dword [ebp - 0x10] ;compare with m
            je .output
            
            ;read a
            sub esp, 0x4
            lea eax, [ebp - 0x1C]
            push eax ;address of a
            push format
            push dword [ebp - 0x4] ;f_in pointer
            call fscanf
            add esp, 0x10
            ;read b
            sub esp, 0x4
            lea eax, [ebp - 0x20]
            push eax ;address of b
            push format
            push dword [ebp - 0x4] ;f_in pointer
            call fscanf
            add esp, 0x10
            
            cmp dword [ebp - 0xC], 0x0 ;compare n with 0
            je .next_iteration ;continue
            mov eax, dword [ebp - 0x18] ;arr pointer
            mov ecx, dword [ebp - 0x1C] ;a
            mov eax, dword [eax + 0x4 * ecx] ;arr[a]
            cmp dword [eax + 0x8], 0x0 ;compare arr[a]->rear with 0
            je .next_iteration ;continue
            
            ;make swap
            mov eax, dword [ebp - 0x18] ;arr pointer
            mov ecx, dword [ebp - 0x20] ;b
            mov ecx, dword [eax + 0x4 * ecx] ;arr[b]
            push ecx ;arr[b]
            mov ecx, dword [ebp - 0x1C] ;a
            mov ecx, dword [eax + 0x4 * ecx] ;arr[a]
            push ecx ;arr[a]
            push dword [ebp - 0x14] ;root pointer
            push dword [ebp - 0x18] ;arr pointer
            call swap
            add esp, 0x10 
            
            .next_iteration:
                inc ebx ;++i
            jmp .stuff_for
    .output:
        mov eax, dword [ebp - 0x18] ;arr pointer
        mov ecx, dword [ebp - 0x14] ;root pointer
        mov ecx, dword [ecx + 0x4] ;root->next
        mov eax, dword [eax + 0x4 * ecx]
        .out_for:
            cmp dword [eax], 0x0 ;compare l->value with 0
            je .free_memory
            
            ;output value
            push eax
            sub esp, 0x4
            push dword [eax] ;value
            push format
            push dword [ebp - 0x8] ;f_out pointer
            call fprintf
            add esp, 0x10
            pop eax
            
            mov ecx, dword [ebp - 0x18] ;arr pointer
            mov eax, dword [eax + 0x4] ;l->next
            mov eax, [ecx + 0x4 * eax] ;l = l->next
            
            jmp .out_for
    .free_memory:
        ;destruct arr
        sub esp, 0x4
        push dword [ebp - 0xC] ;n
        push dword [ebp - 0x14] ;root pointer
        push dword [ebp - 0x18] ;arr pointer
        call destruct
        add esp, 0x10
    .close_files:
        ;f_in
        sub esp, 0xC
        push dword [ebp - 0x4] ;f_in pointer
        call fclose
        add esp, 0x10
        
        ;f_out
        sub esp, 0xC
        push dword [ebp - 0x8] ;f_out pointer
        call fclose
        add esp, 0x10
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret