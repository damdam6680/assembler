[bits 32]

         call getaddr
format  db "zdanie: ", 0
getaddr:
;        esp -> [format0][ret]

         call [ebx+3*4]  ; printf(format0)
         add esp, 4      ; esp + 4

;        esp -> [ret]

call getaddr1
          format   db "A to kanapa pana kota"
          length   equ $ - format
         db 0xA, 0


getaddr1:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf(format); printf(format)

         mov ecx, length  ; ecx = length

         shr ecx, 1  ; ecx = ecx >> 1 = ecx / 2

         jecxz format2  ; jump if ecx is zero ; jump if ecx = 0

         mov esi, [esp]               ; esi = *(int*)esp = format
         lea edi, [esi + length - 1]  ; edi = format + length - 1

_loop:
         mov al, [esi]  ; al = *(char*)esi
         mov ah, [edi]  ; ah = *(char*)edi

         cmp al, ' '     ; compare al to space
         je check_for_space_al  ; jump if equal

         cmp ah, ' '     ; compare ah to space
         je check_for_space_ah  ; jump if equal

         cmp al, 90  ; compare al to 90 ASCII
         jle tolower    ; jump if less or equal
         sub al, 32  ; al -= 32
tolower:
        cmp ah, 90  ; compare al to 90 ASCII
        jle if_palindrom    ; jump if less or equal
        sub ah, 32  ; ah -= 32

if_palindrom:
         cmp al, ah  ; compare al and ah
         jne not_palindrome  ; jump if not equal

         inc esi  ; esi++
         dec edi  ; edi--

         loop _loop
         call getaddr2
format2:
        db "zdanie jest palindromem", 0xA, 0
getaddr2:
;        esp -> [format][ret]
         call [ebx+3*4]  ; printf(format);
         add esp, 4      ; esp = esp + 4

;        esp -> [ret]
         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

not_palindrome:
         call getaddr3
format3:
         db "zdanie nie jest palindromem", 0xA, 0
getaddr3:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("Hello world!\n");
         add esp, 4      ; esp = esp + 4

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);
check_for_space_ah:
         dec edi    ; edi--
         jmp _loop  ; jump always

check_for_space_al:
         inc esi    ; esi++
         jmp _loop  ; jump always


; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387

%ifdef COMMENT

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
