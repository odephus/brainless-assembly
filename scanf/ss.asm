default rel
global main
extern printf
extern scanf
extern ExitProcess

section .data
    prompt db "Enter the number: ",0
    format_in db "%d",0
    spec_result db "AMK SAYI: %d sjsjsjsjsjsj",0x0a,0
    result db "Number is: %d",0

section .bss
    input_val resq 1

section .text
main:
    push rbp
    mov rbp,rsp
    sub rsp,32

    lea rcx, [prompt]
    call printf

    lea rcx, [format_in]
    lea rdx, [input_val]
    call scanf

    mov rax, [input_val]
    cmp rax,31
    jne .p_else

    .p_if:
    lea rcx, [spec_result]
    mov rdx, [input_val]
    call printf
    jmp .p_end

    .p_else:
    lea rcx, [result]
    mov rdx, [input_val]
    call printf
    jmp .p_end

    .p_end:
        xor ecx, ecx
        call ExitProcess