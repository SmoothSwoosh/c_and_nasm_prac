%include "io.inc"

CEXTERN malloc
CEXTERN free
CEXTERN fscanf
CEXTERN fprintf
CEXTERN fclose
CEXTERN fopen

extern printf, scanf

section .data
format db '%d ', 0x0
in_name db 'input.txt', 0x0
in_state db 'r', 0x0
out_name db 'output.txt', 0x0
out_state db 'w', 0x0

;struct list {int x, size; struct list *prev, *next};

section .text
init:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0 
        push ebx
    .allocate_memory_for_root:
        sub esp, 0xC 
        push 0x10 ;for x, size, *prev and *next
        call malloc
        add esp, 0x10 ;eax == *root
    .fill_root:
        mov ebx, dword [ebp + 0x8] ;value
        mov dword [eax], ebx ;l->x = value
        mov dword [eax + 0x4], 0x1 ;size = 1
        mov dword [eax + 0x8], 0x0 ;l->prev = NULL
        mov dword [eax + 0xC], 0x0 ;l->next = NULL
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
    .find_place_to_insert:
        mov ebx, dword [ebp + 0x8] ;*root
        .while_next:
            cmp dword [ebx + 0xC], 0x0
            je .fill_struct
            
            inc dword [ebx + 0x4] ;++size
            mov ebx, dword [ebx + 0xC] ;ebx = ebx->next
            
            jmp .while_next
    .fill_struct:
        ;allocate memory for new element
        sub esp, 0xC
        push 0x10
        call malloc
        add esp, 0x10 ;eax == *new
        
        mov dword [ebx + 0xC], eax ;ebx->next = new
        inc dword [ebx + 0x4] ;++size
        ;fill struct
        mov edx, dword [ebp + 0xC] ;value
        mov dword [eax], edx ;new->x = value
        mov edx, dword [ebx + 0x4]
        mov dword [eax + 0x4], edx ;new->size = ebx->size
        mov dword [eax + 0x8], ebx ;new->prev = ebx
        mov dword [eax + 0xC], 0x0 ;new->next = NULL
    .epilogue:
        xor eax, eax
        pop ebx
        mov esp, ebp
        pop ebp
        ret

bubble_sort:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4 ;for *tmp
        push ebx
    mov eax, dword [ebp + 0x8] ;*root
    mov dword [ebp - 0x4], eax ;tmp = root
    
    mov ebx, 0x0 ;i == 0
    .i_for:
        mov eax, dword [ebp - 0x4] ;l = root
        cmp ebx, dword [eax + 0x4] ;compare i with size
        je .epilogue
        
        .j_for:
            cmp dword [eax + 0xC], 0x0 ;compare l->next with NULL
            je .next_i_iteration
            
            mov ecx, dword [eax + 0xC] ;ecx = l->next
            mov edx, dword [ecx]
            cmp dword [eax], edx ;compare l->x with l->next->x
            jle .next_j_iteration
            ;swap(l->x and l->next->x)
            push ebx ;retain i
            mov edx, dword [eax] ;l->x
            mov ebx, dword [ecx] ;l->next->x
            xchg edx, ebx ;exchange
            mov dword [eax], edx
            mov dword [ecx], ebx
            pop ebx ;get i back
            
            .next_j_iteration:
                mov eax, dword [eax + 0xC] ;l = l->next
            jmp .j_for
   
        .next_i_iteration:
            inc ebx ;++i
        jmp .i_for
        
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
        sub esp, 0x4 ;for tmp
        push ebx
    mov eax, dword [ebp + 0x8] ;root pointer
    .destruct_while:
        cmp eax, 0x0 
        je .epilogue
        
        mov ebx, dword [eax + 0xC] ;ebx = l->next
        mov dword [ebp - 0x4], ebx ;tmp = l->next
        ;free memory
        sub esp, 0x8
        push eax
        call free
        add esp, 0xC
        
        mov eax, dword [ebp - 0x4] ;l = tmp (l = l->next)
        
        jmp .destruct_while
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
        sub esp, 0x10 ;for f_in pointer, f_out pointer, new value, root pointer
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
    .input_elements:
        mov ebx, 0x0 ;i == 0
        .input_for:
            ;try to read new element
            sub esp, 0x4
            lea eax, [ebp - 0xC] ;address of new value
            push eax
            push format ;"%d"
            push dword [ebp - 0x4] ;f_in pointer
            call fscanf
            add esp, 0x10
            
            cmp eax, 0xFFFFFFFF ;compare eax with -1
            je .sort_elements
            
            cmp ebx, 0x0 
            je .init_list
            jmp .insert_into_list
            
            .init_list:
                ;call init
                sub esp, 0xC
                push dword [ebp - 0xC] ;new value
                call init
                add esp, 0x10
                
                mov dword [ebp - 0x10], eax ;root pointer
                jmp .next_iteration
                
            .insert_into_list:
                ;call insert
                sub esp, 0x8
                push dword [ebp - 0xC] ;new value
                push dword [ebp - 0x10] ;root pointer
                call insert 
                add esp, 0x10
                
            .next_iteration:
                inc ebx ;++i
            jmp .input_for        
    .sort_elements: 
        sub esp, 0xC
        push dword [ebp - 0x10] ;root pointer
        call bubble_sort
        add esp, 0x10
    .output:
        mov eax, dword [ebp - 0x10] ;root pointer
        .output_for:   
            cmp eax, 0x0 ;compare with NULL
            je .destruct_list
            
            ;output value
            push eax ;retain pointer
            sub esp, 0x4
            push dword [eax] ;value
            push format ;"%d "
            push dword [ebp - 0x8] ;f_out pointer
            call fprintf
            add esp, 0x10
            pop eax ;get pointer back
            
            mov eax, dword [eax + 0xC]
            jmp .output_for
    .destruct_list:
        ;call destruct
        sub esp, 0xC
        push dword [ebp - 0x10] ;root pointer
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