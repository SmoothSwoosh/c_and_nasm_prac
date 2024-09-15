%include "io.inc"

CEXTERN calloc
CEXTERN free

extern printf, scanf

section .data
format_d db '%d', 0x0
format_lld db '%lld', 0xA, 0x0

section .bss
cur_trace resd 2
max_trace resd 2

section .text
trace:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
        push edi
        push esi
    mov ebx, 0x0 ;i = 0
    mov ecx, dword [ebp + 0xC] ;m
    imul ecx, dword [ebp + 0xC] ;m * m
    mov dword [cur_trace], 0x0 ;cur_trace high = 0
    mov dword [cur_trace + 0x4], 0x0 ;cur_trace least = 0
    mov esi, 0x0 ; j = 0
    .trace_for:
        cmp ebx, ecx ;compare i with m * m
        jge .epilogue
        
        mov eax, ebx ;i
        xor edx, edx
        mov edi, dword [ebp + 0xC] ;m
        div edi ;edx == mod(i / m)

        ;so now arr[i] is diagonal element
        mov edi, dword [ebp + 0x8] ;matrix pointer
        mov edi, dword [edi + 0x4 * ebx] ;arr[i]
        add ebx, dword [ebp + 0xC] ;i += m
        inc ebx ;++i
        ;PRINT_DEC 4, edi
        ;NEWLINE
        
        mov eax, edi ;a.lo
        cdq
        add eax, dword [cur_trace + 0x4] ;a.lo + b.lo
        adc edx, dword [cur_trace] ;a.hi + b.hi
        
        mov dword [cur_trace + 0x4], eax
        mov dword [cur_trace], edx
        
        jmp .trace_for
    .epilogue:
        ;sub esp, 0x4
        ;push dword [cur_trace]
        ;push dword [cur_trace + 0x4]
        ;push format_lld
        ;call printf
        ;add esp, 0x10
        xor eax, eax
        pop esi
        pop edi
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
        sub esp, 0x20
    .input_n:
        ;n
        sub esp, 0x8
        lea eax, [ebp - 0x4] ;n address
        push eax
        push format_d
        call scanf
        add esp, 0x10
    mov dword [ebp - 0xC], 0x0 ;max matrix pointer = NULL
    mov dword [ebp - 0x8], 0x0 ;max size = 0
    mov dword [max_trace], 0x0 ;max high = 0
    mov dword [max_trace + 0x4], 0x0 ;max least = 0
    .input_matrices:
        mov ebx, 0x0 ;i = 0
        .input_for:
            cmp ebx, dword [ebp - 0x4] ;compare i with n
            je .output
            
            ;read m
            sub esp, 0x8
            lea eax, [ebp - 0x14] ;m address
            push eax
            push format_d
            call scanf
            add esp, 0x10
            
            ;allocate memory for new matrix
            mov eax, dword [ebp - 0x14] ;m
            imul eax, dword [ebp - 0x14] ;m * m
            push eax ;retain m * m
            sub esp, 0x8
            push 0x4 ;sizeof(int)
            push eax ;m * m
            call calloc
            add esp, 0x10
            mov dword [ebp - 0x18], eax ;new matrix pointer
            pop eax ;get m * m back
            
            mov edi, eax ;m * m
            mov ecx, 0x0 ;j = 0
            .read_matrix_for:
                cmp ecx, edi ;compare j with m * m
                je .after_read_matrix 
                
                ;read new element
                push ecx ;retain j
                sub esp, 0x8
                mov eax, dword [ebp - 0x18] ;new matrix pointer
                lea eax, [eax + 0x4 * ecx] ;address of new element
                push eax
                push format_d
                call scanf
                add esp, 0x10
                pop ecx ;get j back
                
                inc ecx ;++j
                jmp .read_matrix_for
            
            .after_read_matrix:
                ;take trace of matrix
                sub esp, 0x8
                push dword [ebp - 0x14] ;m
                push dword [ebp - 0x18] ;matrix pointer
                call trace
                add esp, 0x10
            
            cmp dword [ebp - 0xC], 0x0 ;compare max matrix pointer with NULL
            je .make_new_max
            
            ;COMPARE TRACES
            mov eax, dword [cur_trace + 0x4] ;cur low
            cmp dword [max_trace + 0x4], eax ;max low
            mov eax, dword [max_trace] ;max high
            sbb eax, dword [cur_trace] ;cur high
            setl al
            movzx eax, al
            
            cmp eax, 0x0
            je .free_matrix
                
            .make_new_max:
                ;free memory for max
                sub esp, 0xC
                push dword [ebp - 0xC] ;max matrix pointer
                call free
                add esp, 0x10
                
                mov eax, dword [ebp - 0x18] ;new matrix pointer
                mov dword [ebp - 0xC], eax ;max matrix pointer = new matrix pointer
                mov eax, dword [ebp - 0x14] ;m
                mov dword [ebp - 0x8], eax ;max size = m
                mov eax, dword [cur_trace + 0x4] ;cur low 
                mov dword [max_trace + 0x4], eax ;max low = cur low
                mov eax, dword [cur_trace] ;cur high
                mov dword [max_trace], eax ;max high = cur high
                
                jmp .next_iteration
                
            .free_matrix:
                ;so cur_trace here is lower than max_trace and we need to free memory for cur matrix
                sub esp, 0xC
                push dword [ebp - 0x18] ;new matrix pointer
                call free
                add esp, 0x10
                jmp .next_iteration
                
            .next_iteration:
                inc ebx ;++i
            jmp .input_for
    .output:
        mov ebx, 0x0 ;i = 0
        mov ecx, dword [ebp - 0x8] ;m
        imul ecx, dword [ebp - 0x8] ;m * m
        .output_for:
            cmp ebx, ecx ;compare i with m * m
            je .free_memory
            
            cmp ebx, 0x0 ;compare i with 0
            je .output_element
            
            mov eax, ebx ;i
            xor edx, edx
            mov edi, dword [ebp - 0x8] ;m
            div edi ;edx == mod(i / m)
            
            cmp edx, 0x0 ;compare mod with 0
            jne .output_element
            NEWLINE
            
            .output_element:
                mov eax, dword [ebp - 0xC] ;max matrix pointer
                mov eax, dword [eax + 0x4 * ebx] ;matrix[i]
                PRINT_DEC 4, eax
                PRINT_CHAR ' '
            
            inc ebx ;++i
            jmp .output_for
    .free_memory:
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret