; Inspired from Assembly step by step, Wiley, p 220

section .data

    snippet db "KANGAROO" ; The word to lower case
section .text

    global _start
_start:

    mov ebx, snippet ; store the address of the first letter of the word in snippet
    mov eax, 8 ; store the length of the word into eax register

for_each_character:
    add byte [ebx], 32  ; To the value stored in ebx, add 32.
                        ; In ASCII, lower case letter is 32 "bigger" than upper case
                        ; For example: "K" is 75 and "k" is 107. 107 - 75 = 32
                        ; So adding 32 to the value, "for ascii, is like going lower case"
    inc ebx             ; Increment ebx, so that we point to the address of the next letter
    dec eax             ; decrement eax, keep track of how many letters left
    jnz for_each_character ; As long as eax's value did not reach 0 (so still letters to convert), repeat

; WRTIE TO STDOUT THE LOWERED SNIPPET
    mov eax, 4          ; System call write
    mov ebx, 1          ; to stdout
    mov ecx, snippet    ; indicate the address of the first letter of the snippet
    mov edx, 8          ; indicate the length of the nsippet
    int 80H             ; yolo

    ; EXIT CLEAN
    mov eax, 1
    mov ebx, 0
    int 80H
    

section .bss