; ==============================================================================
;  x64-PortInsight - High-Performance Hardware & Device Identifier
;  Developed by: odephus (https://github.com/odephus)
;  Architecture: x64 Windows (NASM)
; ==============================================================================

bits 64

default rel
global main

;----- External WIN API / C runtime functions -----
extern printf
extern ExitProcess
extern SetupDiGetClassDevsA
extern SetupDiEnumDeviceInfo
extern SetupDiDestroyDeviceInfoList
extern SetupDiGetDeviceRegistryPropertyA

; ---  SetupAPI Constants ---
%define DIGCF_PRESENT 0x00000002
%define DIGCF_ALLCLASSES 0x00000004

%define SPDPR_DEVICEDESK 0x00000000
%define SPDPR_HARDWAREID 0x00000001
%define SPDPR_MFG 0x0000000B

section .data 
    banner db "==================================================", 10, \
              "        x64 PC Device Identifier v1.0", 10, \
              "        Developed by: odephus", 10, \
              "==================================================", 10, 10, 0

    msg_scanning db "[i] Scanning system for ALL active devices...",10,0
    fmt_str db "%s",0

    msg_device_found db "[+] Device Detected!",10,0
    fmt_desc db "  -> Description  : %s",10,0
    fmt_mfg  db "  -> Manufacturer : %s",10,0
    fmt_hwid db "  -> Hardware ID  : %s",10,0
    nl db 10,0
    
section .bss

    buffer_desc resb 1024
    buffer_mfg  resb 1024
    buffer_hwid resb 1024

    dev_info_data resb 32

section .text

main:
    push rbp
    mov rbp, rsp
    sub rsp, 48

    ; Print Banner ↓
    mov rcx, fmt_str
    mov rdx, banner
    call printf

    mov rcx, fmt_str
    mov rdx, msg_scanning
    call printf

    ; Get Device List for ALL Present Classes
    xor rcx, rcx
    xor rdx, rdx
    xor r8, r8
    mov r9d, (DIGCF_PRESENT | DIGCF_ALLCLASSES)
    call SetupDiGetClassDevsA

    cmp rax, -1
    je .error_exit

    mov r12, rax

    xor rbx, rbx

    .loop_devices:
        mov dword [dev_info_data], 32

        mov rcx, r12
        mov rdx, rbx
        lea r8,[dev_info_data]
        call SetupDiEnumDeviceInfo

        test rax,rax
        jz .loop_end

        mov rcx, fmt_str
        mov rdx, msg_device_found
        call printf

        ; Get Device Description
        mov rcx, r12
        lea rdx, [dev_info_data]
        mov r8d, SPDPR_DEVICEDESK
        xor r9, r9
        lea rax,[buffer_desc]
        mov [rsp + 32], rax
        mov dword [rsp + 40], 1024
        mov qword [rsp + 48], 0
        call SetupDiGetDeviceRegistryPropertyA

        test rax, rax
        jz .skip_desc

        mov rcx, fmt_desc
        lea rdx, [buffer_desc]
        call printf

    .skip_desc:
        ; Get Device Manufacturer
        mov rcx, r12
        lea rdx, [dev_info_data]
        mov r8d, SPDPR_MFG
        xor r9, r9
        lea rax, [buffer_mfg]
        mov [rsp + 32], rax
        mov dword [rsp + 40], 1024
        mov qword [rsp + 48], 0
        call SetupDiGetDeviceRegistryPropertyA

        test rax, rax
        jz .skip_mfg

        mov rcx, fmt_mfg
        lea rdx, [buffer_mfg]
        call printf

    .skip_mfg:
        ; Get Hardware ID (Pure global standard, no language barrier)
        mov rcx, r12
        lea rdx, [dev_info_data]
        mov r8d, SPDPR_HARDWAREID
        xor r9, r9
        lea rax, [buffer_hwid]
        mov [rsp + 32], rax
        mov dword [rsp + 40], 1024
        mov qword [rsp + 48], 0
        call SetupDiGetDeviceRegistryPropertyA

        test rax, rax
        jz .skip_hwid

        mov rcx, fmt_hwid
        lea rdx, [buffer_hwid]
        call printf

    .skip_hwid:
        mov rcx, fmt_str
        mov rdx, nl
        call printf

        inc rbx
        jmp .loop_devices

    .loop_end:
        mov rcx, r12
        call SetupDiDestroyDeviceInfoList

    .success_exit:
        xor ecx, ecx
        call ExitProcess

    .error_exit:
        mov ecx, 1
        call ExitProcess