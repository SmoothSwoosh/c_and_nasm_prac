%include "io.inc"

CEXTERN fprintf
CEXTERN fscanf
CEXTERN malloc
CEXTERN free
CEXTERN fopen
CEXTERN fclose
CEXTERN strncpy
CEXTERN strlen
CEXTERN strcmp
CEXTERN getchar

extern printf, scanf

section .bss
ans_pair resd 3 ;this is pair which contains answer on each request

section .data
format_d db '%d', 0x0
format_dn db '%d %d', 0xA, 0x0
format_un db '%u', 0xA, 0x0
format_s db '%s', 0x0
format_u db '%u', 0x0
in_state db 'r', 0x0
in_name db 'input.txt', 0x0
out_state db 'w', 0x0
out_name db 'output.txt', 0x0

;struct Node {int data, int height,
;               struct Node *left_child, struct Node *right_child, int key}

section .text
new_Node:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .allocate_memory:
        sub esp, 0xC
        push 0x14 ;20 bytes for data, height, *left_child, *right_child, int key
        call malloc
        add esp, 0x10 ;eax == new node pointer
        
        mov ebx, dword [ebp + 0x8] ;key 
        mov dword [eax + 0x10], ebx ;new->key = key
        mov ebx, dword [ebp + 0xC] ;data
        mov dword [eax], ebx ;new->data = data
        mov dword [eax + 0x4], 0x1 ;new->height = 1
        mov dword [eax + 0x8], 0x0 ;new->left_child = NULL
        mov dword [eax + 0xC], 0x0 ;new->right_child = NULL
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

height:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    cmp dword [ebp + 0x8], 0x0 ;compare cur with NULL
    je .ans_zero
    
    ;take cur->height
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0x4] ;cur->height
    jmp .epilogue
    .ans_zero:
        mov eax, 0x0
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

cur_height:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    ;take cur->left_child
    mov ecx, dword [ebp + 0x8] ;cur pointer
    mov ecx, dword [ecx + 0x8] ;cur->left_child
    ;take height(cur->left_child)
    sub esp, 0xC
    push ecx ;cur->left_child
    call height
    add esp, 0x10 
    mov ebx, eax ;ebx = height(cur->left_child)
    
    ;take cur->right_child
    mov ecx, dword [ebp + 0x8] ;cur pointer
    mov ecx, dword [ecx + 0xC] ;cur->right_child
    ;take height(cur->right_child)
    sub esp, 0xC
    push ecx ;cur->right_child
    call height
    add esp, 0x10
    mov ecx, eax ;ecx = height(cur->right_child)
    
    cmp ebx, ecx ;compare height(cur->left_child) with height(cur->right_child)
    jl .right_inc
    inc ebx ;++lheight
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov dword [eax + 0x4], ebx ;cur->height = max(lheight, rheight) + 1
    jmp .epilogue
    .right_inc:
        inc ecx ;++rheight
        mov eax, dword [ebp + 0x8] ;cur pointer
        mov dword [eax + 0x4], ecx ;cur->height = max(lheight, rheight) + 1
    .epilogue:
        xor eax, eax
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
difference:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    ;take height(cur->right_child)
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0xC] ;cur->right_child
    
    sub esp, 0xC
    push eax ;cur->right_child
    call height
    add esp, 0x10 
    mov ebx, eax ;so ebx == height(cur->right_child)
    
    ;take height(cur->left_child)
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0x8] ;cur->left_child
    
    sub esp, 0xC
    push eax ;cur->left_child
    call height
    add esp, 0x10 ;so eax == height(cur->left_child)
    xchg eax, ebx ;so now eax == height(cur->right_child), ebx == height(cur->left_child)
    sub eax, ebx ;eax == height(cur->right_child) - height(cur->left_child)
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
Right_Rotate:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    ;take cur->left_child
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0x8] ;tmp == cur->left_child
    push eax ;retain tmp
    mov ebx, dword [eax + 0xC] ;tmp->right_child
    
    ;make cur->left_child = tmp->right_child
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov dword [eax + 0x8], ebx ;cur->left_child = tmp->right_child
    ;make tmp->right_child = cur
    pop eax
    mov ebx, dword [ebp + 0x8] ;cur pointer
    mov dword [eax + 0xC], ebx ;tmp->right_child = cur
    
    push eax
    ;call cur_height(cur)
    sub esp, 0xC
    push dword [ebp + 0x8] ;cur pointer
    call cur_height
    add esp, 0x10
    
    pop eax ;get tmp back
    ;call cur_height(tmp)
    mov ebx, eax
    sub esp, 0xC
    push eax ;tmp
    call cur_height
    add esp, 0x10
    
    mov eax, ebx ;return tmp
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
Left_Rotate:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    ;take cur->right_child
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0xC] ;tmp == cur->right_child
    push eax ;retain tmp
    mov ebx, dword [eax + 0x8] ;tmp->left_child
    
    ;make cur->right_child = tmp->left_child
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov dword [eax + 0xC], ebx ;cur->right_child = tmp->left_child
    ;make tmp->left_child = cur
    pop eax
    mov ebx, dword [ebp + 0x8] ;cur pointer
    mov dword [eax + 0x8], ebx ;tmp->left_child = cur
    
    push eax
    ;take cur_height(cur)
    sub esp, 0xC
    push dword [ebp + 0x8] ;cur pointer
    call cur_height
    add esp, 0x10
    
    pop eax ;get tmp back
    ;take cur_height(tmp)
    mov ebx, eax
    sub esp, 0xC
    push eax ;tmp
    call cur_height
    add esp, 0x10
    
    mov eax, ebx ;return tmp
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

balancing:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    ;take cur_height(cur)
    sub esp, 0xC
    push dword [ebp + 0x8] ;cur pointer
    call cur_height
    add esp, 0x10 
    
    ;take difference(cur)
    sub esp, 0xC
    push dword [ebp + 0x8] ;cur pointer
    call difference
    add esp, 0x10 ;now eax == difference(cur)
    
    cmp eax, 0x2 ;compare dif with 2
    je .dif_is_2
    
    cmp eax, 0xFFFFFFFE ;compare dif with -2
    je .dif_is_minus_2
    
    mov eax, dword [ebp + 0x8] ;cur pointer
    jmp .epilogue
    
    .dif_is_2:
        ;take difference(cur->right_child)
        sub esp, 0xC
        mov eax, dword [ebp + 0x8] ;cur pointer
        push dword [eax + 0xC] ;cur->right_child
        call difference
        add esp, 0x10 ;eax == difference(cur->right_child)
        
        cmp eax, 0x0 ;compare dif with 0
        jge .2_return
        ;take cur->right_child
        mov eax, dword [ebp + 0x8] ;cur pointer
        ;make Right_Rotate(cur->right_child)
        sub esp, 0xC ;cur->right_child
        push dword [eax + 0xC] ;cur->right-child
        call Right_Rotate
        add esp, 0x10
        
        mov ebx, dword [ebp + 0x8] ;cur pointer
        mov dword [ebx + 0xC], eax ;cur->right_child = Right_Rotate(cur->right_child)
        .2_return:
            ;make Left_Rotate(cur)
            sub esp, 0xC
            push dword [ebp + 0x8] ;cur pointer
            call Left_Rotate
            add esp, 0x10
            jmp .epilogue
    
    .dif_is_minus_2:
        ;take cur->left_child
        mov eax, dword [ebp + 0x8] ;cur pointer
        ;take difference(cur->left_child)
        sub esp, 0xC
        push dword [eax + 0x8] ;cur->left_child
        call difference
        add esp, 0x10 ;eax == difference(cur->left_child)
        
        cmp eax, 0x0 ;compare dif with 0
        jle .minus_2_return
        ;take cur->left_child
        mov eax, dword [ebp + 0x8] ;cur pointer
        mov ebx, dword [eax + 0x8] ;cur->left_child
        ;take Left_Rotate(cur->left_child)
        sub esp, 0xC
        push ebx ;cur->left_child
        call Left_Rotate
        add esp, 0x10
        
        mov ebx, dword [ebp + 0x8] ;cur pointer
        mov dword [ebx + 0x8], eax ;cur->left_child = Left_Rotate(cur->left_child)
        .minus_2_return:
            ;take Right_Rotate(cur)
            sub esp, 0xC
            push dword [ebp + 0x8] ;cur pointer
            call Right_Rotate
            add esp, 0x10
            jmp .epilogue
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

add_data:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4 ;for new string pointer
        push ebx
    .check_cur:
        cmp dword [ebp + 0x8], 0x0 ;compare cur pointer with NULL
        je .make_new_node
   
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0x10] ;cur->key
    cmp dword [ebp + 0xC], eax ;compare key with cur->key
    jl .lower
    jg .greater
    je .equal
    .make_new_node:
        ;make new_Node(key, data)
        sub esp, 0x4
        push dword [ebp + 0x10] ;data
        push dword [ebp + 0xC] ;key
        call new_Node
        add esp, 0xC
        jmp .epilogue
    .lower:
        ;make cur->left_child
        mov eax, dword [ebp + 0x8] ;cur pointer
        mov eax, dword [eax + 0x8] ;cur->left_child
        ;make add_data(cur->left_child, key, data)
        push dword [ebp + 0x10] ;data
        push dword [ebp + 0xC] ;key
        push eax ;cur->left_child
        call add_data
        add esp, 0xC
        
        mov ebx, dword [ebp + 0x8] ;cur pointer
        mov dword [ebx + 0x8], eax ; cur->left_child = add_data(cur->left_child, key, data)
        jmp .balance
    .greater:
        ;make cur->right_child
        mov eax, dword [ebp + 0x8] ;cur pointer
        mov eax, dword [eax + 0xC] ;cur->right_child
        ;make add_data(cur->right_child, key, data)
        push dword [ebp + 0x10] ;data
        push dword [ebp + 0xC] ;key
        push eax ;cur->right_child
        call add_data
        add esp, 0xC
        
        mov ebx, dword [ebp + 0x8] ;cur pointer
        mov dword [ebx + 0xC], eax ; cur->right_child = add_data(cur->right_child, key, data)
        jmp .balance
    .equal:
        mov ebx, dword [ebp + 0xC] ;key
        mov eax, dword [ebp + 0x8] ;cur pointer
        mov dword [eax + 0x10], ebx ;cur->key = key
        mov ebx, dword [ebp + 0x10] ;data
        mov dword [eax], ebx ;cur->data = data
        jmp .balance 
    .balance:
        ;call balancing(cur)
        sub esp, 0x8
        push dword [ebp + 0x8] ;cur pointer
        call balancing
        add esp, 0xC
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

contains:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    cmp dword [ebp + 0x8], 0x0 ;compare cur with NULL
    je .cur_is_NULL
    
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0x10] ;cur->key
    cmp dword [ebp + 0xC], eax ;check is key equal cur->key
    je .equal
    jl .left_contains
    
    ;take contains(cur->right_child, key)
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov eax, dword [eax + 0xC] ;cur->right_child
    sub esp, 0x8
    push dword [ebp + 0xC] ;key
    push eax ;cur->right_child
    call contains
    add esp, 0x10
    jmp .epilogue

    .cur_is_NULL:
        lea eax, [ans_pair] ;pair pointer
        mov dword [eax], 0x0 ;false
        mov dword [eax + 0x4], 0x0
        mov dword [eax + 0x8], 0x0 
        jmp .epilogue
    
    .equal:
        lea eax, [ans_pair] ;pair pointer
        mov dword [eax], 0x1 ;true
        mov ebx, dword [ebp + 0x8] ;cur pointer
        mov ebx, dword [ebx + 0x10] ;cur->key
        mov dword [eax + 0x4], ebx ;cur->key
        mov ebx, dword [ebp + 0x8] ;cur pointer
        mov ebx, dword [ebx] ;cur->data
        mov dword [eax + 0x8], ebx ;cur->data
        jmp .epilogue
    
    .left_contains:
        ;take contains(cur->left_child, key)
        mov eax, dword [ebp + 0x8] ;cur pointer
        mov eax, dword [eax + 0x8] ;cur->left_child        
        sub esp, 0x8
        push dword [ebp + 0xC] ;key
        push eax ;cur->left_child
        call contains
        add esp, 0x10
        jmp .epilogue
        
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
avl_min:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov ecx, dword [eax + 0x8] ;cur->left_child
    cmp ecx, 0x0 ;compare cur->left_child with NULL
    je .epilogue
    
    ;call avl_min(cur->left_child)
    sub esp, 0xC
    push ecx ;cur->left_child
    call avl_min
    add esp, 0x10
    
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret

avl_remove_min: 
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov eax, dword [ebp + 0x8] ;cur pointer
    mov ecx, dword [eax + 0x8] ;cur->left_child
    cmp ecx, 0x0 ;compare cur->left_child with NULL
    je .return_right
    
    ;call avl_remove_min(cur->left_child)
    sub esp, 0xC
    push ecx ;cur->left_child
    call avl_remove_min
    add esp, 0x10
    
    mov ebx, dword [ebp + 0x8] ;cur pointer
    mov dword [ebx + 0x8], eax ;cur->left_child = avl_remove_min(cur->left_child)
    
    ;make balancing(cur)
    sub esp, 0xC
    push dword [ebp + 0x8] ;cur pointer
    call balancing
    add esp, 0x10
    jmp .epilogue
    
    .return_right:
        mov eax, dword [eax + 0xC] ;cur->right_child
        
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
        
removing:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov eax, dword [ebp + 0x8] ;cur pointer
    cmp eax, 0x0 ;compare cur pointer with NULL
    je .epilogue
    
    mov ebx, dword [eax + 0x10] ;cur->key
    cmp dword [ebp + 0xC], ebx ;compare key with cur->key
    jl .lower
    jg .greater
    je .equal
    
    .lower: 
        ;call removing(cur->left_child, key)
        push eax
        sub esp, 0x8
        push dword [ebp + 0xC] ;key
        push dword [eax + 0x8] ;cur->left_child
        call removing
        add esp, 0x10
        mov ebx, eax ;ebx = removing
        pop eax 
        
        mov dword [eax + 0x8], ebx ;cur->left_child = removing
        jmp .balance
        
    .greater:
        ;call removing(cur->right_child, key)
        push eax
        sub esp, 0x8
        push dword [ebp + 0xC] ;key
        push dword [eax + 0xC] ;cur->right_child
        call removing
        add esp, 0x10
        mov ebx, eax ;ebx = removing
        pop eax
        
        mov dword [eax + 0xC], ebx ;cur->right_child = removing
        jmp .balance
    
    .equal:
        push dword [eax + 0x8] ;retain cur->left_child
        push dword [eax + 0xC] ;retain cur->right_child
        
        ;make free(cur)
        sub esp, 0xC
        push dword [ebp + 0x8] ;cur pointer
        call free
        add esp, 0x10
        
        pop ebx ;ebx = cur->right_child
        pop eax ;eax = cur->left_child
        
        cmp ebx, 0x0 ;compare cur->right_child with NULL
        je .epilogue ;return cur->left_child
        
        ;make avl_min(cur->right_child)
        push eax ;retain cur->left_child
        sub esp, 0xC
        push ebx ;cur->right_child
        call avl_min
        add esp, 0x10 
        mov ecx, eax ;ecx(tmp) == avl_min(cur->right_child)
        pop eax ;eax == cur->left_child
        ;make avl_remove_min(cur->right_child)
        push eax ;retain cur->left_child
        push ecx ;retain tmp
        sub esp, 0xC
        push ebx ;cur->right_child
        call avl_remove_min
        add esp, 0x10
        pop ecx ;get tmp back into ecx
        mov dword [ecx + 0xC], eax ;tmp->right_child = avl_remove_min(cur->right_child)
        pop eax ;get cur->left_child back into eax
        mov dword [ecx + 0x8], eax ;tmp->left_child = cur->left_child
        
        ;make balancing(tmp)
        sub esp, 0xC
        push ecx ;tmp
        call balancing
        add esp, 0x10
        jmp .epilogue
    
    .balance:
        ;make balancing(cur)
        sub esp, 0xC
        push dword [ebp + 0x8] ;cur pointer
        call balancing
        add esp, 0x10
        
    .epilogue:
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
    mov eax, dword [ebp + 0x8] ;cur pointer
    cmp eax, 0x0 ;compare cur with NULL
    je .epilogue
        
    mov ebx, dword [eax + 0x8] ;cur->left_child
    mov ecx, dword [eax + 0xC] ;cur->right_child
    cmp ebx, ecx ;compare cur->left_child with cur->right_child
    je .epilogue
    
    ;desruct(cur->right_child)
    push ecx
    sub esp, 0xC
    push ecx 
    call destruct
    add esp, 0x10
    pop ecx 
    
    ;destruct(cur->left_child)
    push ecx
    sub esp, 0xC
    push ebx
    call destruct
    add esp, 0x10
    pop ecx
    
    sub esp, 0xC
    push dword [ebp + 0x8]
    call free
    add esp, 0x10

    .epilogue:
        xor eax, eax
        pop ebx
        mov esp, ebp
        pop ebp
        ret

global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0x1C ;for f_in pointer, f_out pointer, root pointer, n, m, data, key
    mov dword [ebp - 0xC], 0x0 ;root pointer = NULL
    .add_data_into_tree:
        .while_read:
            ;get symbol
            sub esp, 0x4
            call getchar
            add esp, 0x4 ;eax == symbol
            
            cmp eax, 0x41 ;compare with 'A'
            je .add
            cmp eax, 0x44 ;compare with 'D'
            je .delete
            cmp eax, 0x53 ;compare with 'S'
            je .search
            cmp eax, 0x46 ;compare with 'F'
            je .free_memory
            jmp .while_read
            
            .add:
                ;read key
                sub esp, 0xC
                lea eax, [ebp - 0x1C]
                push eax ;address of key
                push format_d
                call scanf
                add esp, 0x14
                
                ;read data
                sub esp, 0xC
                lea eax, [ebp - 0x18]
                push eax ;address of data
                push format_d
                call scanf
                add esp, 0x14
                
                ;call add_data
                sub esp, 0x8
                push dword [ebp - 0x18] ;data
                push dword [ebp - 0x1C] ;key
                push dword [ebp - 0xC] ;root pointer
                call add_data
                add esp, 0x14
                
                mov dword [ebp - 0xC], eax ;root pointer = add_data
                jmp .while_read
            
            .search:
                ;read key
                sub esp, 0xC
                lea eax, [ebp - 0x1C]
                push eax ;address of key
                push format_d
                call scanf
                add esp, 0x14
                
                ;call contains(root, key)
                sub esp, 0xC
                push dword [ebp - 0x1C] ;key
                push dword [ebp - 0xC] ;root pointer
                call contains
                add esp, 0x14
                
                cmp dword [ans_pair], 0x0 ;compare flag with false
                je .while_read
                
                ;output key and data
                sub esp, 0x8
                push dword [ans_pair + 0x8] ;data
                push dword [ans_pair + 0x4] ;key
                push format_dn
                call printf
                add esp, 0x14
                jmp .while_read
            
            .delete:
                ;read key
                sub esp, 0xC
                lea eax, [ebp - 0x1C] 
                push eax ;address of key
                push format_d
                call scanf
                add esp, 0x14
                
                ;call removing(root, key)
                sub esp, 0xC
                push dword [ebp - 0x1C] ;key
                push dword [ebp - 0xC] ;root pointer
                call removing
                add esp, 0x14
                mov dword [ebp - 0xC], eax ;root pointer = removing
            
            jmp .while_read
    .free_memory:
        push dword [ebp - 0xC] ;root pointer
        call destruct
        add esp, 0x4
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret