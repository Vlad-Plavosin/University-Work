bits 32 ; assembling for the 32 bits architecture
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 2
    b dw 2
    c dd 2
    c2 dd 2
    d dq 2
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, [c]
        mov [c2], eax
        mov al, [a]
        mov ah, 0
        add ax, [b]
        add [c+0], ax
        mov eax, dword[d+0]
        mov edx, dword[d+4]
        clc
        add eax, eax
        adc edx, edx
        mov dword[d+0],eax
        mov dword[d+4],edx
        mov ax, [b]
        add [c2+0], ax
        mov eax, [c2]
        add eax, [c]
        cdq
        clc
        sub eax, [d+0]
        sbb edx, [d+4]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
