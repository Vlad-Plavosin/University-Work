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
    d dq 2
    d2 dq 2
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al, [a]
        cbw
        add ax, [b]
        mov [b], ax ; b are val a+b
        cwde
        sub eax, [c] 
        mov [c], eax ; c are val a+b-c
        
        mov ax, [b]
        cwde
        cdq
        clc
        add eax, dword[d+0]
        adc edx, dword[d+4]
        mov dword[d+0],eax
        mov dword[d+4],edx ; d are val a+b+d
        
        mov eax, [c]
        cdq
        clc
        add eax, dword[d+0]
        adc edx, dword[d+4]
        mov dword[d+0],eax
        mov dword[d+4],edx
        
        mov ax, [b]
        cwde
        cdq
        mov dword[d2+0],eax
        mov dword[d2+4],edx
        mov eax, dword[d+0]
        mov edx, dword[d+4]
        sub eax, dword[d2+0]
        sbb edx, dword[d2+4]
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
