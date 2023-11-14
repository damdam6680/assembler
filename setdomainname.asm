section .data
    domain_name db 51 DUP(0) ; Maximum domain name length + 1 for null terminator
    error_set_domain_msg db "Error setting domain name", 0
    error_set_domain_msg_len equ $ - error_set_domain_msg
    path_prompt db "Enter domain name: ", 0
    path_prompt_len equ $ - path_prompt

section .text
    global _start

_start:
    ; Display the prompt
    mov eax, 4               ; sys_write
    mov ebx, 1               ; stdout
    mov ecx, path_prompt     ; pointer to the prompt
    mov edx, path_prompt_len ; length of the prompt
    int 0x80

    ; Read user input for domain name
    mov eax, 3               ; sys_read
    mov ebx, 0               ; stdin
    mov ecx, domain_name     ; buffer to store user input
    mov edx, 50              ; maximum length to read
    int 0x80

    ; Remove newline character from user input
    mov ecx, 0
find_newline:
    cmp byte [domain_name + ecx], 10 ; Check for newline character
    je  remove_newline
    cmp byte [domain_name + ecx], 0  ; Check for null terminator
    je  skip_remove_newline
    inc ecx
    jmp find_newline

remove_newline:
    mov byte [domain_name + ecx], 0  ; Replace newline with null terminator

skip_remove_newline:

    ; Set the domain using setdomainname syscall
    mov eax, 121     ; Syscall number for setdomainname
    mov ebx, domain_name
    mov ecx, 50       ; Maximum length of the domain name
    int 0x80         ; Invoke syscall

    ; Check for errors during setting the domain
    cmp eax, 0
    jl error_set_domain

    ; Exit the program
    mov eax, 1       ; Syscall number for exit
    xor ebx, ebx     ; Exit code 0
    int 0x80         ; Invoke syscall

error_set_domain:
    ; Handle error setting the domain
    mov eax, 4       ; Syscall number for write
    mov ebx, 2       ; File descriptor for stderr
    mov ecx, error_set_domain_msg
    mov edx, error_set_domain_msg_len
    int 0x80         ; Invoke syscall

    ; Exit the program with an error code
    mov eax, 1       ; Syscall number for exit
    xor ebx, 1       ; Exit code 1 (indicating an error)
    int 0x80         ; Invoke syscall
