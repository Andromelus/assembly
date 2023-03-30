
section .data
    read_bytes_size: equ 1
    graph_header: db "graph LR", 10
    graph_header_len: equ $-graph_header
section .bss
    read_input_buffer: resb read_bytes_size

section .text
    global _start
    _start:                     ; read user input

; WRITE "graph LR" to STDOUT
    mov eax, 4
    mov ebx, 1
    mov ecx, graph_header
    mov edx, graph_header_len
    int 80h
; READ filename from STDIN
    _read_filename:
    # TODO error here if more than one byte provided
        mov eax, 3
        mov ebx, 0
        mov ecx, read_input_buffer
        mov edx, read_bytes_size
        int 80H
        cmp eax, -1
       
        .read_byte:

; READ content of filename
    ; clear current concated bytes
    ; concat bytes until space is found
    ; IF SPACE FOUND
        ; IF grouped bytes = "CREATE"
            ; set CREATE_FLAG to true
            ; JMP READ content of filename
    ; IF (grouped bytes = "TABLE" or "EXTERNAL") && CREATE_FLAG
        ; JMP READ content of filename
    ; ELSE
        ; STORE the grouped bytes (it's the name of the table to create)
        ; set CREATE_FLAG to false
        ; JMP READ content of filename

    mov eax,1
    mov ebx,0
    int 80H



