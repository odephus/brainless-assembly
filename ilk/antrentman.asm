default rel
global main
extern printf
extern ExitProcess

section .data
    rword db "Selam Dünya Ben Alper", 0x0a,0

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp , 32

    lea rcx, [rword]
    call printf

    xor ecx, ecx
    call ExitProcess