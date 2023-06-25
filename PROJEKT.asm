        [bits 32]

N        equ 100
length   equ 0

         sub esp, N+1

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db 'zdanie: ', 0
getaddr:
         call [ebx+3*4]  ; printf('ascii = %d\n', eax);
         add esp, 2*4    ; esp = esp + 8

         mov esi,0  ; esi = 0

_loop:
         cmp esi,N
         jg _end
         call [ebx+2*4]  ; eax = getchar();
         cmp eax,0xA
         je _end
         push eax
         inc esi
         jmp _loop

_end:
         mov edx,esi
         mov edi,0
         dec esi
         mov ecx, esi

_loop2:
         mov al, [esp+edi*4]
         mov ah, [esp+ecx*4]

         cmp ah, 32     ; compare ah to space
         je check_for_space_ah  ; jump if equal

         cmp al, 32    ; compare al to space
         je check_for_space_al  ; jump if equal

         cmp al,90
         jge tolower
         add al,32

tolower:
         cmp ah, 90  ; compare al to 90 ASCII
         jge if_palindrom    ; jump if greater or equal
         add ah, 32  ; ah += 32

if_palindrom:
         cmp al, ah
         jne done

         inc edi
         dec ecx

         cmp edi, edx
         jne _loop2

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db 0xA, 'zdanie jest palindromem', 0xA, 0
getaddr2:

         call [ebx+3*4]  ; printf('ascii = %d\n', eax);
         add esp, 2*4    ; esp = esp + 8

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0)

done:
         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr

format3:
         db 0xA, 'zdanie nie jest palindromem', 0xA, 0
getaddr3:
         call [ebx+3*4]  ; printf('ascii = %d\n', eax);
         add esp, 2*4    ; esp = esp + 8

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0)

check_for_space_ah:
         dec ecx    ; edi--
         jmp _loop2  ; jump always

check_for_space_al:
         inc edi    ; esi++
         jmp _loop2  ; jump always
