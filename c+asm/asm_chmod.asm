section .data
    path db 0

section .text
    global asm_chmod

asm_chmod:
    ; Argumenty:
    ; [esp+4] - wskaźnik do ścieżki
    ; [esp+8] - prawa dostępu

    ; Przeniesienie wskaźnika do ścieżki do rejestru ebx
    mov ebx, [esp+4]

    ; Przeniesienie prawa dostępu do rejestru ecx
    mov ecx, [esp+8]

    ; Wywołanie systemowe chmod (sys_chmod)
    mov eax, 15             ; sys_chmod
    int 0x80

    ret
