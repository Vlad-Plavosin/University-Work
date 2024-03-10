bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    
import printf msvcrt.dll
import scanf msvcrt.dll
; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a resd 1
    b resd 1
    sign dd 60
    f dd "%d", 0
    message dd "< %d > %c < %d >", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword a
        push dword f
        call [scanf]
        add esp, 4*2
        
        push dword b
        push dword f
        call [scanf]
        add esp, 4*2
        
        mov eax, [a]
        cmp eax, [b]
        je equal
        ja larger
        mov ebx, 60
        jmp print
        equal:
        mov ebx, 61
        jmp print
        larger:
        mov ebx, 62
        jmp print
        
        print:
        mov [sign], ebx
        push dword [b]
        push dword [sign]
        push dword [a]
        push message
        call [printf]
        add esp, 4*4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
