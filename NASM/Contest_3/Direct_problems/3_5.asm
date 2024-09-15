%include "io.inc"

extern printf, scanf

section .data
format_in db '%u', 0x0
format_out_str db '%s', 0xA, 0x0
format_out_uint db '%u', 0x0
yes db 'Yes', 0x0
no db 'No', 0x0

section .text
reverse:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x8 ;for reversed number and number
        push ebx
    mov dword [ebp - 0x4], 0x0 ;reversed number == 0
    mov ebx, dword [ebp + 0x8]
    mov dword [ebp - 0x8], ebx ;number
    .while_n_more_than_0:
        cmp dword [ebp - 0x8], 0x0
        je .epilogue
        
        xor edx, edx
        mov eax, dword [ebp - 0x8]
        mov ecx, 0xA
        div ecx ;edx == mod (number / 10), eax == div (number / 10)
        mov dword [ebp - 0x8], eax
        
        mov ebx, edx ;retain remainder
        
        mov eax, dword [ebp - 0x4]
        mov ecx, 0xA
        mul ecx ;reversed number *= 10
        mov dword [ebp - 0x4], eax
        add dword [ebp - 0x4], ebx ;reversed number = reversed number * 10 + remainder
        
        mov eax, dword [ebp - 0x4] ;eax == reversed number
        jmp .while_n_more_than_0
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret
       
check_for_palindrome:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    .call_reverse:
        sub esp, 0xC
        push dword [ebp + 0x8]
        call reverse
        add esp, 0x10
    .is_a_palindrome:
        cmp eax, dword [ebp + 0x8]
        je .make_yes
        mov eax, 0x0
        jmp .epilogue
    .make_yes:
        mov eax, 0x1
    .epilogue:
        pop ebx
        mov esp, ebp
        pop ebp
        ret 

palindrome:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x4
        push ebx
    mov ebx, 0x0 ;i == 0
    mov eax, dword [ebp + 0x8] 
    mov dword [ebp - 0x4], eax ; == m
    .loop:
        cmp ebx, dword [ebp + 0xC] ;compare with n
        jge .epilogue
        
        ;call function to find reverse for number
        sub esp, 0x8
        push dword [ebp - 0x4]
        call reverse
        add esp, 0xC ;eax == reverse_number
        
        add dword [ebp - 0x4], eax 
        mov eax, dword [ebp - 0x4] ;eax == ans
        inc ebx ;++i
        jmp .loop
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
        sub esp, 0x8 ;for m and n
    .input:
        ;m
        lea eax, [ebp - 0x4]
        push eax
        push format_in
        call scanf
        add esp, 0x8
        
        ;n
        lea eax, [ebp - 0x8]
        push eax
        push format_in
        call scanf
        add esp, 0x8 
    .call_function:
        push dword [ebp - 0x8]
        push dword [ebp - 0x4]
        call palindrome
        add esp, 0x8
    .output:
        mov ebx, eax ;retain result
    
        ;check ans for palindrome shape
        sub esp, 0x4
        push eax
        call check_for_palindrome
        add esp, 0x8
        
        cmp eax, 0x0 ;eax == 0x0 if this is not a palindrome
        je .output_no
        jmp .output_yes
    .output_yes:
        ;output 'Yes'
        push yes
        push format_out_str
        call printf
        add esp, 0x8
        
        ;output palindrome
        push ebx
        push format_out_uint
        call printf
        add esp, 0x8
        
        jmp .epilogue
    .output_no:
        ;output 'No'
        push no
        push format_out_str
        call printf
        add esp, 0x8
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret