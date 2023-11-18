section .data
    path db 256 DUP(0)     ; Variable to store the file path
    format db "%s", 0
    message db "Podaj path: ", 0

    mode db 4       ; Variable to store the access mode
    format1 db "%o", 0
    message1 db "Podaj tryb dostępu (w oktalnym formacie np. 0777): ", 0

    error_format db "Błąd: %d", 10, 0 ; Format string for printing errors

section .text
    global main
    extern printf, scanf

main:
    ; Print the first message ("Podaj path: ")
    push message
    call printf
    add esp, 4      ; Pop the argument from the stack

    ; Read input from the user into the path variable
    lea eax, [path]
    push eax
    push format
    call scanf
    add esp, 8      ; Pop the arguments from the stack


    ; Print the second message ("Podaj tryb dostępu (w oktalnym formacie): ")
    push message1
    call printf
    add esp, 4      ; Pop the argument from the stack

    ; Read input from the user into the mode variable
    lea eax, [mode]
    push eax
    push format1
    call scanf
    add esp, 8      ; Pop the arguments from the stack

    mov eax, 15             ; sys_chmod                                     
    mov ebx, path
    mov ecx, [mode]
    int 0x80

    ; Check for chmod error
    cmp eax, 1
    jl chmod_error

    ; Exit the program
    mov eax, 0
    ret

chmod_error:
    ; Print an error message for chmod
    push eax
    push error_format
    call printf
    add esp, 8      ; Pop the arguments from the stack

exit_program:
    ; Exit the program with a return value of 1
    mov eax, 1
    ret

section .note.GNU-stack
