main.exe: main.o
	ld -o main.exe main.o -m elf_i386
main.o: main.asm
	nasm -f elf -g -F stabs main.asm
