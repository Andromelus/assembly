# Introduction

Some assembly code.

# Environment

Unless specified otherwise, all these programs have been developped on:
- Virtualbox 6.1.14
- Ubuntu (ran on virtual box) 18.04.6 LTS (Bionic Beaver)
- Host: Windows 10 X64, I7-8750H CPU.

Tools:
- nasm version 2.13.02
- ld 2.30


# Notes

- Registers have different sizes.

## Conventions

- The leftmost operand is the destination
- The second operand from the left is the source

## Data types

- Memory data
  - Stored in memory, 32 bits mem address
  - It is not possible to move from memory to memory, except in the following two cases (still true ?):
  - It is possible to access the memory address stored in a register with:
    - mov eax, [ebx] --> copy content located in memory at address known in ebx into the eax register
  - Something within brackets is called the effective address of data in memory
- Register data
  - Into CPU's registers
- Immediate data
  - Accessed through immediate addressing, means the item is built into the machine instruction. Cpu does not go anywhere to find it
  - THe source code is stored in memory, so pulling data from a register is still faster

## MOV

Move data from an address in memory to another address in memory, or to a register.

Can move:
- A byte
- A word (16 bits)
- A double word (32 bits)

**NOTE**: it actually copies. After executed, data exist in both places.

Difference between moving data and data address:
```asm
string: db "my string"  ; store into string the memoery address of the string "my string"
mov ecx, string         ; move into ecx register the address of the string
mov edx, [string]       ; move into edx register the value of the string located at string
```
