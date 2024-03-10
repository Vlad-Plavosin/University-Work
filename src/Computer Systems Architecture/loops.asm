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
    max_poz_pare db 0
    min_poz_impare db 255
    array db 1,4,2,3,8,4,9,5
    lenS db $-array
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, [lenS]
        mov bl, 2
        div bl
        mov ecx, eax
        mov edx, array
        
        for1:
        mov al, [edx]
        cmp [min_poz_impare], al
        jb mai_mare
        mov [min_poz_impare], al
        mai_mare:
        add edx, 2
        loop for1
        
        mov eax, [lenS]
        mov bl, 2
        div bl
        mov ecx, eax
        mov edx, array
        add edx, 1
        
        for2:
        mov al, [edx]
        cmp [max_poz_pare], al
        ja mai_mic
        mov [max_poz_pare], al
        mai_mic:
        add edx, 2
        loop for2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
