; This programs reads from STDIN
; It sends this content back to STDOUT
; It replaces CR (0xd) and LF (0xa) by space (0x20)
; It reads a number from invocation parameters (1 to 255 --> 1 byte number only)
; This number represents the number of character per ligne and must not
;   take into account the EOL LF.
; The EOL LF will not be replaced
; If the parameter number is incorrect, output will not be correctly formatted
; (you will lose EOL LF)

; Compile and link with:
; ld -o main.exe main.o -m elf_i386 && 
; nasm -f elf -ggdb -F stabs main.asm

; Run with:
;  ./main.exe 8 <toto.txt
; Where toto contains:
; 1234|678
; 1234|<cr>
; 7
; 1234|678
; 1234|
; 78
; Output:
;/app/asm # ./main.exe 8 <toto.txt
; 1234|678
; 1234|  7
; 1234|678
; 1234| 78

section .data

section .bss
    line_length: resb 1
    count_buffer: resb 1
    input_buffer: resb 1

section .text
    global _start
    _start:

        mov byte [count_buffer], 0

        ; using ATOI, gets the first command line argument, transform it into
        ; a number.
        _get_line_length:
            mov eax, 0
            mov ecx, [esp+8] ; ecx pointe sur la stack à l'emplacement du premier parametre

            _atoi:
                movzx esi, byte [ecx] ; store into esi a the byte at adress where ecx points to

                cmp esi, 0              ; compare esi with 0 (NULL char)
                jz _check_line_length   ; if esi = 0, jump to _check_line_length

                cmp esi, 48             ; compare esi with 48 ("0" char)
                jl _exit_1              ; if esi is lower than 0, exit in error

                cmp esi, 57             ; compare esi with 57 ("9" char)
                jg _exit_1              ; if esi is greater, exit in error

                sub esi, 48             ; substract 48 to esi (transforms the char into its decimal equivalent)
                imul eax, 10            ; multiply eax by 10
                add eax, esi            ; add esi to eax
                inc ecx                 ; make ecx point to the next byte
                jmp _atoi               ; jump to _atoi (loop)

        _check_line_length:
            cmp eax, 0
            jz _exit_1  ; TODO message erreur
            jl _exit_1  ; TODO message erreur
            add al, 1   ; Take expected linefeed into account (the mandatory LF)
            push ax     ; push al (ax because can't push less that 16 bits) to the stack. Acces later via [esp]

        _read_stdin:

            add byte [count_buffer], 1  ; increase loop counter

            mov eax, 3
            mov ebx, 0
            mov ecx, input_buffer
            mov edx, 1
            int 80H

            cmp eax, -1 ; if error, exit input
            jz _exit_1
            cmp eax, 0 ; if 0, then no more content to read
            jz _exit_0

            xor eax, eax
            mov ax, [esp]  ; get the line length. We get two bytes, the lower end is in al, the higher one is in ah
            mov ah, [count_buffer] ; get the current loop counter

            cmp al, ah  ; compare nbr char read and line length

            jz _finish_process_line

            jmp _process_char

        _finish_process_line:
            mov byte [count_buffer], 0
            jmp _stdout

        _process_char:
            mov ecx, [ecx]  ; store the value of the memory ecx points at to the ecx reg
            cmp cl, 0xa ; compare the lower byte of ecx 32 bits to LF
            jz .replace_char
            cmp cl, 0xd
            jz .replace_char ; compare the lower byte of ecx 32 bits to CR
            jmp _stdout

            .replace_char:
                xor ecx, ecx    ; clean the ecx reg
                mov cl, 20h    ; set cl reg to space
                mov [input_buffer], cl ; move value to input_buffer memory
                jmp _stdout

        _stdout:
            mov eax, 4
            mov ebx, 1
            mov edx, 1
            mov ecx, input_buffer
            int 80H
            jmp _read_stdin

        _exit_0:
            mov eax, 1
            mov ebx, 0
            int 80H

        _exit_1:
            mov eax, 1
            mov ebx, 1
            int 80H