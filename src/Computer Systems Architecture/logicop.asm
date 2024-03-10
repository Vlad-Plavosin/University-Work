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
    a dw 0A27Bh
    b dd 0FFFFFFFFh
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; mov ecx, [b]
        mov al, [a+1]
        shl al, 4
		mov [b], al
        
        ; mov ecx, [b]
        mov al, [a]
        shl al, 6
        rol al, 2
        not al
        and [b+1], al
        rol al, 2
        and [b+1], al
        
        ; mov ecx, [b]
        or word[b], 0F000h
		
        ; mov ecx, [b]
        mov ax, word[b]
        mov [b+2], ax
        ; mov ecx, [b]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
