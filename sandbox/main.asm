section .data
    max_number_size: equ 32 ; max length of read input
section .bss
    input_buffer: resb 32 ; used to store input number

section .text
    global _start

_start:
    mov eax, 3 ; sys call read
    mov ebx, 0 ; from FD 0
    mov ecx, input_buffer ; indicate the adress of the memory buffer
    mov edx, max_number_size ; read this quantity of character
    int 80H
    mov eax, input_buffer
    mov ebx, max_number_size
    mov ecx, 0
    jmp count

count:

    add ecx, eax
    dec eax
    jnz count

    mov eax, 4 ; sys call write
    mov ebx, 1 ; to stdout
    int 80H


    mov eax, 1 ; sys call exit
    mov ebx, 0
    int 80H