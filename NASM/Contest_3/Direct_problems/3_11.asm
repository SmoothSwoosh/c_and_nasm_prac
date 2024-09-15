%include "io.inc"

extern printf, scanf

section .data
format db '%u', 0x0
format_out db '%s', 0xA, 0x0
yes db 'YES', 0x0
no db 'NO', 0x0

section .text
take_abs:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
    .make_abs:
        mov edx, eax
        sar edx, 0x1F
        xor eax, edx
        sub eax, edx
    .epilogue: 
        mov esp, ebp
        pop ebp
        ret

div3:
    .prologue:
        push ebp
        mov ebp, esp
        sub esp, 0x0
        push ebx
    mov eax, 0x0
    cmp dword [ebp + 0x8], 0x2
    jae .loop_and_recurse
    mov eax, dword [ebp + 0x8]
    jmp .epilogue
    .loop_and_recurse:
        mov ebx, dword [ebp + 0x8] 
        mov ecx, 0x0 ;even
        .loop:
            cmp ebx, 0x0
            je .after_loop
            push ebx ;retain number
            
            and ebx, 0x1 ;0 or 1
            
            cmp ecx, 0x0 
            je .even
            .odd:
                mov ecx, 0x0 ;so next would be even
                sub eax, ebx
                jmp .next_it
            .even:
                mov ecx, 0x1 ;so next would be odd
                add eax, ebx
            .next_it:
                pop ebx
                shr ebx, 0x1 ;number >>= 1
            jmp .loop
        .after_loop:
            ;make abs(eax)
            sub esp, 0xC
            push eax
            call take_abs
            add esp, 0x10 ;eax == abs(eax)
            .recurse:
                ;call div3(eax)
                sub esp, 0xC
                push eax
                call div3
                add esp, 0x10 
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
        sub esp, 0x8 ;for n and element
    .input_n:
        lea eax, [ebp - 0x4]
        push eax
        push format
        call scanf
        add esp, 0x8
    mov ebx, 0x0 ;i == 0
    .loop:
        cmp ebx, dword [ebp - 0x4]
        jge .epilogue
        
        ;input element
        lea eax, [ebp - 0x8]
        push eax
        push format
        call scanf
        add esp, 0x8
        
        ;call div3(element)
        sub esp, 0x4
        push dword [ebp - 0x8]
        call div3
        add esp, 0x8
        
        cmp eax, 0x0
        je .output_yes
        .output_no:
            push no
            push format_out
            call printf
            add esp, 0x8
            jmp .next_it
        .output_yes:
            push yes
            push format_out
            call printf
            add esp, 0x8
        .next_it:
            inc ebx ;++i
        jmp .loop
    .epilogue:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret