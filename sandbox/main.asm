; TODO: trouver le nombre d'octets nécessaire pour stocker
; la somme de tous les entiers positifs inférieurs à un nombre donné
section .data
    max_number_size: equ 2 ; max length of read input
section .bss
    input_buffer: resb max_number_size ; used to store input number
section .text
global _start
_start:
    mov eax, 3                  ; sys call read
    mov ebx, 0                  ; from FD 0
    mov ecx, input_buffer       ; indicate the adress of the memory buffer where the bytes will be stored
    mov edx, max_number_size    ; read this quantity of character
    int 80H                     ; store max_number_size to input_buffer from STDIN

atoi:
    mov eax, 0              ; Set initial total to 0
     
convert:
    mov esi, [ecx]   ; Get the current character
    test esi, esi           ; Check for \0
    je _write_stdout
   
    cmp esi, 48             ; Anything less than 0 is invalid
    jl _exit_1
   
    cmp esi, 57             ; Anything greater than 9 is invalid
    jg _exit_1
     
    sub esi, 48             ; Convert from ASCII to decimal
    imul eax, 10            ; Multiply total by 10
    add eax, esi            ; Add current digit to total
   
    inc ecx                 ; Get the address of the next character
    jmp convert

; _calculate_sum:
; For each positive integer lower than the given number,
; calculate the some of all these integers

_write_stdout:
    mov eax, 4
    mov ebx, 1
    mov ecx, eax
    mov edx, max_number_size

_exit_0:
    mov eax, 1
    mov ebx, 0
    int 80H

_exit_1:
    mov eax, 1
    mov ebx, 1
    int 80H


