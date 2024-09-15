%include "io.inc"

CEXTERN malloc
CEXTERN free
CEXTERN fopen
CEXTERN fclose
CEXTERN fread
CEXTERN calloc

extern printf, scanf

section .data
format db '%d ', 0x0
in_name db 'input.bin', 0x0
in_state db 'rb', 0x0

section .text
recurse:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
        push ecx
    .do_this:
        mov eax, dword [ebp + 0xC] ;index
        mov ecx, dword [ebp + 0x8] ;arr pointer
        mov eax, dword [ecx + 0x4 * eax] ;arr[index]

        ;output value
        push eax ;retain eax
        sub esp, 0x8
        push dword [eax] ;value
        push format
        call printf
        add esp, 0x10 
        pop eax ;get eax back
        
        cmp dword [eax + 0x4], 0xFFFFFFFF ;compare left_child with -1
        jne .left_recurse
        
        .check_right:
            cmp dword [eax + 0x8], 0xFFFFFFFF ;compare right_child with -1
            jne .right_recurse
        
        jmp .epilogue
        
        .left_recurse:
            ;call recurse of left_child
            push eax ;retain eax
            sub esp, 0x8
            push dword [eax + 0x4] ;left_child
            push dword [ebp + 0x8] ;arr pointer
            call recurse
            add esp, 0x10
            pop eax ;get eax back
            jmp .check_right
        
        .right_recurse:
            ;call recurse of right_child
            push eax ;retain eax
            sub esp, 0x8
            push dword [eax + 0x8] ;right_child
            push dword [ebp + 0x8] ;arr pointer
            call recurse
            add esp, 0x10
            pop eax ;get eax back
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
        sub esp, 0x18 ;for f_in pointer, root index, arr pointer, value, left_child, right_child
    .open_file:
        ;f_in
        push in_state
        push in_name
        call fopen
        add esp, 0x8 
        mov dword [ebp - 0x4], eax ;f_in pointer
    .allocate_memory_for_array:
        push 0x4 ;sizeof(int)
        push 0x27100 ;40000 
        call calloc
        add esp, 0x8
        mov dword [ebp - 0xC], eax ;arr pointer
    .read_information:
        mov dword [ebp - 0x8], 0x0 ;root index = 0
        mov ebx, 0x0 ;i == 0
        .while_read:    
            ;try to read value
            sub esp, 0x8
            push dword [ebp - 0x4] ;f_in pointer
            push 0x1 ;count
            push 0x4 ;sizeof(int)
            lea eax, [ebp - 0x10]
            push eax ;value address
            call fread
            add esp, 0x18

            cmp eax, 0x0
            je .just_do_it ;if we didnt read anything
            
            ;allocate memory for new node in array
            sub esp, 0x4
            push 0xC ;for value, left_child and right_child
            call malloc
            add esp, 0x8
            
            ;add value
            mov ecx, dword [ebp - 0xC] ;arr pointer
            mov dword [ecx + 0x4 * ebx], eax ;new node pointer
            mov ecx, dword [ebp - 0x10] ;value
            mov dword [eax], ecx ;new node.value = value
            
            ;read left_child
            sub esp, 0x8
            push dword [ebp - 0x4] ;f_in pointer
            push 0x1 ;count
            push 0x4 ;sizeof(int)
            lea eax, [ebp - 0x14]
            push eax ;left_child address
            call fread
            add esp, 0x18
            
            ;add left_child
            mov ecx, dword [ebp - 0xC] ;arr pointer
            mov ecx, dword [ecx + 0x4 * ebx] ;new node pointer
            mov eax, dword [ebp - 0x14] ;left_child
            mov dword [ecx + 0x4], eax ;new node.left_child = left_child
            
            cmp eax, 0xFFFFFFFF ;compare left_child with -1
            je .read_right_child
            
            ;rewrite left_child
            xor edx, edx 
            push ebx ;retain i
            mov ebx, 0x4
            div ebx
            pop ebx ;get i back into ebx
            mov dword [ecx + 0x4], eax ;new node.left_child = left_child
            
            .read_right_child:
                sub esp, 0x8
                push dword [ebp - 0x4] ;f_in pointer
                push 0x1 ;count
                push 0x4 ;sizeof(int)
                lea eax, [ebp - 0x18]
                push eax ;right_child address
                call fread
                add esp, 0x18
                
            ;add right_child
            mov ecx, dword [ebp - 0xC] ;arr pointer
            mov ecx, dword [ecx + 0x4 * ebx] ;new node pointer
            mov eax, dword [ebp - 0x18] ;right_child
            mov dword [ecx + 0x8], eax ;new node.right_child = right_child
            
            cmp eax, 0xFFFFFFFF ;compare right_child with -1
            je .next_iteration
            
            ;rewrite right_child
            xor edx, edx 
            push ebx ;retain i
            mov ebx, 0x4
            div ebx
            pop ebx ;get i back into ebx
            mov dword [ecx + 0x8], eax ;new node.right_child = right_child
            
            .next_iteration:    
                add ebx, 0x3 ;i += 3
            jmp .while_read
    .just_do_it:
        ;find root index
        mov ebx, 0x0 ;i == 0
        .while_not_bound:
            mov eax, dword [ebp - 0xC] ;arr pointer
            mov eax, dword [eax + 0x4 * ebx] ;ith node pointer
            cmp eax, 0x0
            je .make_recurse
            
            mov ecx, 0x0 ;j == 0
            mov edi, 0x0 ;flag = false
            .small_while:
                mov eax, dword [ebp - 0xC] ;arr pointer
                mov eax, dword [eax + 0x4 * ecx] ;jth node pointer
                cmp eax, 0x0
                je .check
                
                cmp dword [eax + 0x4], ebx ;compare left_child with i
                je .flag_true_break
                
                cmp dword [eax + 0x8], ebx ;compare right_child with i
                je .flag_true_break
                jmp .next_j_iteration
                
                .flag_true_break:
                    mov edi, 0x1 ;flag = True
                    jmp .check
                .next_j_iteration:
                    add ecx, 0x3 ;j += 3
                jmp .small_while
                
            .check:
                cmp edi, 0x1 ;compare flag with True
                jne .make_index
            add ebx, 0x3 ;i += 3
            jmp .while_not_bound
        .make_index:
            mov dword [ebp - 0x8], ebx ;root index = ebx
        .make_recurse:
            ;call recurse
            push dword [ebp - 0x8] ;root index
            push dword [ebp - 0xC] ;arr pointer        
            call recurse
            add esp, 0x8
    .free_memory:
        mov ebx, 0x0
        .free_for:
            mov eax, dword [ebp - 0xC] ;arr pointer
            mov eax, dword [eax + 0x4 * ebx] ;node pointer
            cmp eax, 0x0
            je .free_array
            
            ;free node
            sub esp, 0x4
            push eax
            call free
            add esp, 0x8
            
            inc ebx ;i += 3
            jmp .free_for
        .free_array:
            sub esp, 0x4
            push dword [ebp - 0xC] ;arr pointer
            call free
            add esp, 0x8
    .close_file:
        push dword [ebp - 0x4] ;f_in pointer
        call fclose
        add esp, 0x4
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret