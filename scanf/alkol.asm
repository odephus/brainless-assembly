default rel
global main
extern printf
extern scanf
extern ExitProcess

section .data 
    buyuk db "Alkol Alabilir",0x0a,0
    kucuk db "Alkol Alamaz",0x0a,0

    age_in db "Yasşınızı Girin: ",0
    format_in db "%d",0

section .bss
    input_val resq 1

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    lea rcx,[age_in]
    call printf

    lea rcx,[format_in]
    lea rdx, [input_val]
    call scanf

    mov rax, [input_val]
    cmp rax, 18
    jl .p_else

    .p_if:
        lea rcx,[buyuk]
        call printf
        jmp .p_end

    .p_else:
        lea rcx,[kucuk]
        call printf
        jmp .p_end

    .p_end:
        xor ecx,ecx
        call ExitProcess