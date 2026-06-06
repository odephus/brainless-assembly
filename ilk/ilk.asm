default rel ;RIP-releative addressing (Windows için gerekli(x64)) 
global main
extern printf
extern ExitProcess

section .data 
    msg db "Hello, World! aga", 0x0a, 0
    
section .text

main :
    push rbp ;stack frame koru
    mov rbp, rsp
    sub rsp, 32 ; sahdow space aç

    lea rcx, [msg]
    call printf

    xor ecx, ecx
    call ExitProcess
