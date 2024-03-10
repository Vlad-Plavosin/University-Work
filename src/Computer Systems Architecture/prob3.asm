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
    x dq 2
    x2 dq 2
    x3 dq 2

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]
        imul byte[a]
        add ax, [b]
        cwde
        cdq
        clc
        add eax, dword[x+0]
        adc edx, dword[x+4]
        mov dword[x+0],eax
        mov dword[x+4],edx ; x are prima paranteza
        
        mov ax, [b]
        add ax, [b]
        cwde
        mov [x2],eax ; x2 are a doua
        
        mov eax, [c]
        imul dword[c]
        mov dword[x3+0],eax
        mov dword[x3+4],edx ; x3 a treia
        
        mov eax, dword[x+0]
        mov edx, dword[x+4]
        mov ebx, [x2]
        idiv ebx
        add eax,[x3]
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
