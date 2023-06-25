        [bits 32]
        
;        esp -> [ret]  ; ret - adres powrotu do asmloader

N        equ 100
length   equ 0

         sub esp, N+1  ; esp = esp + N+1

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db 'zdanie: ', 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf(format);
         add esp, 4      ; esp = esp + 4

;        esp -> [ret]

         mov esi,0  ; esi = 0

_loop:
         cmp esi, N      ; eax - N          ; OF SF ZF AF PF CF affected
         jg _end         ; jump if greater  ; jump if SF == OF and ZF = 0
         call [ebx+2*4]  ; eax = getchar()
         cmp eax, 0xA    ; eax - 0xA          ; OF SF ZF AF PF CF affected
         je _end         ; jump if equal

         push eax        ; esp -> eax

;        esp -> [eax][ret]

         inc esi    ; esi++
         jmp _loop  ; jump always

_end:
         mov edx, esi  ; edx = esi
         mov edi, 0    ; edi = 0
         dec esi       ; esi--
         mov ecx, esi  ; ecx = esi

_loop2:
         mov al, [esp+edi*4]  ; al = *(char*)edi*4
         mov ah, [esp+ecx*4]  ; ah = *(char*)ecx*4

         cmp ah, 32             ; compare ah to space
         je check_for_space_ah  ; jump if equal

         cmp al, 32             ; compare al to space
         je check_for_space_al  ; jump if equal

         cmp al,90    ; compare al to 90 ASCII
         jge tolower  ; jump if greater or equal ; jump if SF == OF or ZF = 1
         add al,32    ; al += 32

tolower:
         cmp ah, 90        ; compare al to 90 ASCII
         jge if_palindrom  ; jump if greater or equal
         add ah, 32        ; ah += 32

if_palindrom:
         cmp al, ah  ; al - ah  ; OF SF ZF AF PF CF affected
         jne done    ; jump if not equal

         inc edi  ; edi++
         dec ecx  ; ecx--

         cmp edi, edx  ; edi - edx  ; OF SF ZF AF PF CF affected
         jne _loop2    ; jump if not equal

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db 0xA, 'zdanie jest palindromem', 0xA, 0
getaddr2:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf(format2);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0)

done:
         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr

format3:
         db 0xA, 'zdanie nie jest palindromem', 0xA, 0
getaddr3:

;        esp -> [format3][eax][ret]

         call [ebx+3*4]  ; printf(format3);
         add esp, 2*4    ; esp = esp + 8
         
;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0)

check_for_space_ah:
         dec ecx     ; edi--
         jmp _loop2  ; jump always

check_for_space_al:
         inc edi     ; esi++
         jmp _loop2  ; jump always
         
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
