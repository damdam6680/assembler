section .data
    path db 256 DUP(0)     ; Zmienna przechowująca tryb dostępu
    format db "%s", 0
    message db "Podaj path: ", 0



    mode db 4       ; Zmienna przechowująca tryb dostępu
    format1 db "%o", 0
    message1 db "Podaj tryb dostępu (w oktalnym formacie): ", 0
;    path:   db "example.txt", 0


section .text
    global main
    extern printf, scanf

main:
    ; Wypisanie komunikatu
    push message
    call printf
    add esp, 4      ; Usunięcie argumentu z stosu

    ; Wczytanie wartości z wejścia
    lea eax, [path]
    push eax
    push format
    call scanf
    add esp, 8      ; Usunięcie argumentów z stosu	
    

    ; Wypisanie komunikatu
    push message1
    call printf
    add esp, 4      ; Usunięcie argumentu z stosu

    ; Wczytanie wartości z wejścia
    lea eax, [mode]
    push eax
    push format1
    call scanf
    add esp, 8      ; Usunięcie argumentów z stosu

    mov eax, 15             ; sys_chmod                                     
    mov ebx, path
    mov ecx, [mode]
    int 0x80

    ; Zakończenie programu
    mov eax, 0
    ret



