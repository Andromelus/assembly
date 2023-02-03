# Introduction

Some assembly code.

- [Introduction](#introduction)
- [Environment](#environment)
- [Notes](#notes)
  - [Conventions](#conventions)
  - [Data types](#data-types)
  - [MOV](#mov)
  - [JNZ - Jump if Not Zero](#jnz---jump-if-not-zero)
- [ATOI](#atoi)
  - [Code](#code)
  - [Explanation](#explanation)
    - [Global concept](#global-concept)
    - [Example](#example)

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


## MOV

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

## JNZ - Jump if Not Zero



Jump to a label if the ZF flag is not set (value = 0). Example:
```assembly
    mov eax, 5
do_more:
    dev eax
    jnz do_more
```
--> As long as the value of eax is not 0, keep "decrement" eax. When eax reaches 0, end.

# ATOI

ATOI = Ascii TO Integer

## Code
The program is the following (Thanks to [tnewman](https://gist.github.com/tnewman/63b64284196301c4569f750a08ef52b2)):

```nasm
atoi:
    mov rax, 0              ; Set initial total to 0
     
convert:
    movzx rsi, byte [rdi]   ; Get the current character
    test rsi, rsi           ; Check for \0
    je done
   
    cmp rsi, 48             ; Anything less than 0 is invalid
    jl error
   
    cmp rsi, 57             ; Anything greater than 9 is invalid
    jg error
     
    sub rsi, 48             ; Convert from ASCII to decimal
    imul rax, 10            ; Multiply total by 10
    add rax, rsi            ; Add current digit to total
   
    inc rdi                 ; Get the address of the next character
    jmp convert

error:
    mov rax, -1             ; Return -1 on error
 
done:
    ret                     ; Return total or error code
```

## Explanation

### Global concept

Assuming that the input is provided as ASCII character, this program loops through all characters (here, stored in rdi). For each character
- test if the character is an integer (``cmp rsi, 48`` and ``cmp rsi, 57``)
- Substitue 48 to the value of the character
  - in ASCII, the decimal value of the "0" character is 48d. Consequently, substituing 48d brings the decimal value to 0d (for char "0") up to 9d (for char "9") (Check an ASCII table for visual representation)
- Multiply the current integer by 10, to "shift" the highest number value from right to left (see table bellow)
- add the value of rsi to the final result

### Example

Given the following input: "12" (ASCII characters)


| INSTRUCTION                   | RAX (bytes) | RSI (decimal) | RSI (bytes) | RSI (char) |
| ----------------------------- | ----------- | ------------- | ----------- | ---------- |
| atoi: mov rax,0               | 0000        |               |             |            |
| convert: movzx rsi, byte[rdi] | 0000        | 49            | 0100 1001   | 1          |
| convert: sub rsi, 48          | 0000        | 1             | 0001        | SOH        |
| convert: imul rax, 10         | 0000        | 1             | 0001        | SOH        |
| convert: add rax, rsi         | 0001        | 1             | 0001        | SOH        |

At this point, the character "1" has been processed. The value of the integer calculated is 1 (rax = 0000 0001b)

----

| INSTRUCTION                   | RAX (bytes) | RSI (decimal) | RSI (bytes) | RSI (char) |
| ----------------------------- | ----------- | ------------- | ----------- | ---------- |
| convert: movzx rsi, byte[rdi] | 0001        | 50            | 0101 0000   | 2          |
| convert: sub rsi, 48          | 0001        | 2             | 0010        | STX        |
| convert: imul rax, 10         | 1010        | 2             | 0010        | STX        |
| convert: add rax, rsi         | 1100        | 2             | 0010        | STX        |

At this point, the characters "1" and "2" have been processed. The value of the integer is 12 (rax = 1100b)