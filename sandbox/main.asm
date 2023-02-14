section .data
    max_number_size: equ 1

section .bss
    input_buffer: resb max_number_size

section .text
    global _start
    _start:                     ; read user input

        mov eax, 3
        mov ebx, 0
        mov ecx, input_buffer       ; tell syscall to store stuff pin input buffer
        mov edx, max_number_size    ; The number of bytes to read
        int 80H
        cmp eax, -1                 ; read returns -1 on error
        jz _exit_1
        mov edi, eax                ; store into edi the number of bytes read

    atoi:
        mov eax, 0                  ; will store the actual number
        mov ebx, 0                  ; keep track of number of char processed

        atoi_convert:
            movzx esi, byte [ecx]   ; move the char at adress ecx into esi.
                                    ; esi is 32 bits, the char is 8, so use movzx with the byte op
            cmp ebx, edi            ; if nbr_char_processed == nbr_char_read then break loop
            je _calculate_sum

            cmp esi, 48             ; Anything less than char 0 is invalid (check ASCII table)
            jl _exit_1

            cmp esi, 57             ; Anything greater than char 9 is invalid (check ASCII table)
            jg _exit_1

            sub esi, 48             ; Convert from ASCII to decimal (0 starts at 48d in ASCII)
            imul eax, 10            ; Multiply total by 10d
            add eax, esi            ; Add current digit to total

            inc ecx                 ; Get the address of the next character
            inc ebx                 ; keep track of nbr of char processed
            jmp atoi_convert

_calculate_sum:
    mov ecx, eax
    mov eax, 0
    .count:
        add eax, ecx
        dec ecx
        cmp ecx, 0
        jne .count

    ; This code is referenced from <https://stackoverflow.com/a/46301894>.
    ; Basically, take each byte, from right to left
    print_uint32:
        xor ebx, ebx                ; set ebx to 0
        mov ecx, 0xa                ; 10
        push ecx                    ; send ecx (10) to the stack
        mov esi, esp
        add esp, 4                  ; point 4 bytes further into the stack
    .toascii_digit:
        inc ebx                     ; Number of digits to output
        xor edx, edx                ; set edx to 0
        div ecx                     ; divide eax by ecx
        add edx, '0'                ; edx contains remainder, add the ascii value of 0 to it. If edx = 5d, then it's equivalent to add edx, 48d -> 53d (which is the decimal value of the char "5" in ascii)
        dec esi                     ; go check the next byte
        mov [esi], dl

        test eax, eax               ; eax is altered by the div above (it gets the quotient of the division)
        jnz .toascii_digit

        mov edx, ebx
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        int 80h

    _exit_0:
        mov eax, 1
        mov ebx, 0
        int 80H

    _exit_1:
        mov eax, 1
        mov ebx, 1
        int 80H