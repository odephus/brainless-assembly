default rel
global main
extern printf
extern scanf
extern ExitProcess

section .data
    prompt_msg db "Enter the number: ",0
    format_in db "%d",0
    result_msg db "Number is: %d",0x0a,0
    ;spec_result db "sjsjsjsjsjsj"

section .bss 
    input_val resq 1

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp , 32

    lea rcx, [prompt_msg]
    call printf

    lea rcx, [format_in]
    lea rdx, [input_val]
    call scanf

    lea rcx, [result_msg]
    mov rdx, [input_val]
    call printf

    xor ecx,ecx
    call ExitProcess