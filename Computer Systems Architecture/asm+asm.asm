bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
%include "invert.asm"
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db "functioneaza te rog frumos domnule "
    f dd "%s", 0
    m dd "%c", 0
    b db " "
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;push dword a
        ;push dword f
        ;call [scanf]
        ;add esp, 4*2
        
        call setup
        mov esi, a
        for:
        lodsb
        add ebx, 1
        push eax
        cmp al, 0
        je sentence_end
        cmp al, [b]
        jne notspace
        xchg ecx, ebx
        for2:
        pop eax
        push ecx
        
        push eax
        push dword m
        call [printf]
        add esp, 4*2
        
        pop ecx
        loop for2
        xchg ebx, ecx
        notspace:
        loop for
        sentence_end:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
