default rel
global main
extern printf
extern ExitProcess

section .data
    msg_if db "Sayi 5'e esit",0x0a,0
    msg_else db "Sayi 5'e esit degil",0x0a,0

section .text
main:
    push rbp
    mov rbp , rsp
    sub rsp, 32

    ;-- IF-ELSE BAŞLANGICI --
    mov rax, 13
    cmp rax,5 ; cmp karşılaştırma operatörü || rax == 5 ? ↓
    jne .p_else ; sonuç farklı ise zıpla

    .p_if:
        lea rcx, [msg_if]
        call printf
        jmp .p_end

    .p_else:
        lea rcx, [msg_else]
        call printf
        jmp .p_end

    .p_end:
        xor ecx, ecx
        call ExitProcess