%include "io.inc"

CEXTERN free
CEXTERN realloc

extern printf, scanf

section .data
format_u db '%u', 0x0

section .text
global CMAIN
CMAIN:
    ;write your code here
    .prologue:
        push ebp
        mov ebp, esp
        and esp, 0xFFFFFFF0
        sub esp, 0xC ;for head of array, new_element and ans
    mov dword [ebp - 0x4], 0x0 ;address of head == NULL
    .input_array:
        mov ebx, 0x0 ;count == 0
        .input_for:
            ;try to read new element
            sub esp, 0xC
            lea eax, [ebp - 0x8] ;address of new element
            push eax
            push format_u
            call scanf
            add esp, 0x14
            
            cmp dword [ebp - 0x8], 0x0 ;compare new element with 0
            je .just_do_it
            inc ebx ;++count
            
            ;allocate memory
            push ebx ;retain count
            sub esp, 0xC
            imul ebx, ebx, 0x4 ;ebx == count * sizeof(int)
            push ebx 
            push dword [ebp - 0x4] ;address of head
            call realloc
            add esp, 0x14
            mov dword [ebp - 0x4], eax ;address of head
            pop ebx ;get count back into ebx
            
            mov ecx, dword [ebp - 0x8] 
            mov dword [eax + 0x4 * ebx - 0x4], ecx ;arr[i] = new element
            
            jmp .input_for
    .just_do_it:
        mov ecx, ebx
        dec ecx ;count - 1
        mov eax, dword [ebp - 0x4] ;address of head
        mov ecx, dword [eax + 0x4 * ecx] ;ecx == arr[count - 1] (its last element of array)
        
        mov dword [ebp - 0xC], 0x0 ;ans == 0
        mov eax, 0x0 ;i == 0
        .ans_loop:
            cmp eax, ebx ;compare with count
            je .output_ans
            
            ;compare ith element with last
            mov edx, dword [ebp - 0x4] ;address of head
            cmp dword [edx + 0x4 * eax], ecx
            jge .next_iteration
            inc dword [ebp - 0xC] ;++ans
            
            .next_iteration:
                inc eax ;++i
            jmp .ans_loop
    .output_ans:
        sub esp, 0xC
        push dword [ebp - 0xC]
        push format_u
        call printf
        add esp, 0x14
    .free_memory:
        push dword [ebp - 0x4]
        call free
        add esp, 0x4
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret