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
    final dd 0
    starting dd 2F00FF00h, 44FF4400h
    len equ $-starting
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov esi, starting
        mov edi, final
        mov ecx, 32
        mov ebx, len
        mov dx, 0
        cld
        
        for1:
        lodsd
        cmp ebx, 0
        je done
        jmp for2
        for2done:
        push eax
        mov ax, dx
        div byte[2]
        cmp ah, 1
        je nu_adaugam
        pop eax
        lodsd
        nu_adaugam:
        
        dec ebx
        mov ecx, 32
        jmp for1
        
        for2:
        sar eax,1
        jnc zero
        add dx, 1
        zero:
        loop for2
        jmp for2done
        done:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
