; Build with
; nasm -f elf -g -F stabs eatsyscall.asm && ld -o eatsyscall eatsyscall.o -m elf_i386

SECTION .data ;init data

eat_msg: db "FLorian mange une poire",10 ; cette variable contient l'adresse du string
eat_len: equ $-eat_msg ; cette var contient la longueur (offset) du string

SECTION .bss ;uninit data
SECTION .text ;code

global _start

_start:
	nop ; ?
	mov eax,4
	mov ebx,1
	mov ecx,eat_msg ; Insert dans ce registre l'adresse du string à afficher
	mov edx,eat_len ; indique la longueur (offset) du string référencé dans le registre ecx
	int 80H ; exécute un "sys_call" (envoi les données dans le terminal actif)

	mov eax,1
	mov ebx,0
	int 80H
