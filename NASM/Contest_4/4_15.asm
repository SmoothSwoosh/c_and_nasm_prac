%include "io.inc"

CEXTERN qsort
CEXTERN realloc
CEXTERN free
CEXTERN strlen
CEXTERN strncpy
CEXTERN malloc
CEXTERN calloc
CEXTERN strcmp

extern printf, scanf

section .data
format_d db '%d', 0x0
format_s db '%s', 0x0

section .text
compar:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov eax, dword [ebp + 0x8] ;first address
    mov ebx, dword [ebp + 0xC] ;second address
    mov eax, dword [eax]
    mov ebx, dword [ebx]
    mov ecx, dword [eax + 0x8] ;first count
    mov edx, dword [ebx + 0x8] ;second count
    cmp ecx, edx
    jg .make_ans_minus_one
    jl .make_ans_one
    
    ;so first count == second count
    mov ecx, dword [eax + 0x4] ;first fine
    mov edx, dword [ebx + 0x4] ;second fine
    cmp ecx, edx
    jg .make_ans_one
    jl .make_ans_minus_one
    
    ;so first fine == second fine
    mov ecx, dword [eax] ;first name
    mov edx, dword [ebx] ;second name
    ;call strcmp(ecx, edx)
    sub esp, 0x8
    push edx
    push ecx
    call strcmp
    add esp, 0x10
    cmp eax, 0x0
    je .make_ans_zero
    jl .make_ans_minus_one
    jg .make_ans_one
    
    .make_ans_minus_one:
        mov eax, 0xFFFFFFFF ;ans = -1
        jmp .epilogue
    
    .make_ans_one:
        mov eax, 0x1 ;ans = 1
        jmp .epilogue
        
    .make_ans_zero:
        mov eax, 0x0 ;ans = 0
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
        sub esp, 0x20 ;arr pointer, string, penalty (fine), count, size of array, max_len1, max_len2, max_len3
    mov dword [ebp - 0x4], 0x0 ;arr pointer = NULL
    ;allocate memory for string
    sub esp, 0xC
    push 0x15 ;21 bytes
    call calloc
    add esp, 0x10
    mov dword [ebp - 0x8], eax ;string pointer

    mov ebx, 0x0 ;i == 0
    mov dword [ebp - 0x18], 0x0 ;len1 = 0
    mov dword [ebp - 0x1C], 0x0 ;len2 = 0
    mov dword [ebp - 0x20], 0x0 ;len3 = 0
    .input_for:
        ;try to read string
        sub esp, 0x4
        push dword [ebp - 0x8] ;string pointer
        push format_s
        call scanf
        add esp, 0xC
        
        cmp eax, 0xFFFFFFFF ;compare eax with -1
        je .sort_array
        
        ;realloc
        
        sub esp, 0x4
        mov eax, ebx ;i
        inc eax
        imul eax, eax, 0x4 ;(i + 1) * 4
        push eax ;size
        push dword [ebp - 0x4] ;arr pointer
        call realloc
        add esp, 0xC
        mov dword [ebp - 0x4], eax ;arr pointer = new pointer
      
        ;allocate memory for new string
        sub esp, 0x8
        push 0x15 ;21 bytes
        call calloc
        add esp, 0xC ;eax == new string pointer

        push eax ;retain new string pointer
        ;take strlen(string)
        sub esp, 0x8
        push dword [ebp - 0x8] ;string pointer
        call strlen
        add esp, 0xC
        mov ecx, eax ;ecx == strlen(string)
        pop eax ;new string pointer
        
        push eax ;retain new string pointer
        push ecx
        ;strncpy(new string, string, strlen(string))
        push ecx ;strlen(string)
        push dword [ebp - 0x8] ;string pointer
        push eax ;new string pointer
        call strncpy
        add esp, 0xC 
        pop ecx ;strlen(new string)
        pop eax ;new string pointer
            
        mov byte [eax + ecx], 0x0 
        
        ;allocate memory for new node
        push eax ;retain new string pointer
        sub esp, 0x8
        push 0xC ;for new string, fine and count
        call malloc
        add esp, 0xC 
        pop ecx ;ecx == new string pointer
        
        mov edx, dword [ebp - 0x4] ;arr pointer
        lea edx, [edx + 0x4 * ebx] ;address of arr[i]
        mov dword [edx], eax ;arr[i] = new node pointer
        
        mov dword [eax], ecx ;new node->string = new string pointer
        
        ;read fine
        push eax
        sub esp, 0x4
        lea eax, [ebp - 0xC] ;address of fine
        push eax
        push format_d
        call scanf
        add esp, 0xC
        pop eax
        mov ecx, dword [ebp - 0xC]
        mov dword [eax + 0x4], ecx ;new node->fine = fine
        
        ;read count
        push eax
        sub esp, 0x4
        lea eax, [ebp - 0x10] ;address of count
        push eax
        push format_d
        call scanf
        add esp, 0xC
        pop eax
        mov ecx, dword [ebp - 0x10]
        mov dword [eax + 0x8], ecx ;new node->count = count
        
        inc ebx ;++i
        jmp .input_for
    .sort_array:
        mov dword [ebp - 0x14], ebx ;retain size of array
        ;call qsort
        sub esp, 0x8
        push compar
        push 0x4 ;sizeof(int)
        push dword [ebp - 0x14] ;size of array
        push dword [ebp - 0x4] ;arr pointer
        call qsort
        add esp, 0x18
    .output:
    .free_memory:
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret