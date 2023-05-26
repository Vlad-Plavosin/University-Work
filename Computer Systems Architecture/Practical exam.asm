bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,fscanf,printf,fopen,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import scanf msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    access_mode db "r",0
    file_name times 15 db " ",0
    file_descriptor dd -1
    
    c dd 0
    n dd 0
    caracter dd 0
    occurences dd 0
    
    outputformat1 db "The number of occurrences of the character %c is NOT equal to the read number %d", 0
    outputformat2 db "The number of occurrences of the character %c IS equal to the read number %d", 0
    format1 dd "%s", 0
    format2 dd "%c", 0
    format3 dd "%d", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push dword c
        push dword format2
        call [scanf]
        add esp,4*2
        
        push dword n
        push dword format3
        call [scanf]
        add esp,4*2
        
        push dword file_name
        push dword format1
        call [scanf]
        add esp,4*2
        
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp,4*2
        
        mov [file_descriptor], eax
        cmp eax,0
        je finalloop
        
        verificare:
        push caracter
        push format2
        push dword [file_descriptor]
        call [fscanf]
        
        cmp eax, -1
        je finalloop
        
        mov eax, [caracter]
        cmp eax, [c]
        jne diferit
        add dword[occurences],1
        
        
        diferit:
        
        jmp verificare
        
        finalloop:
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        mov eax, [n]
        cmp eax, [occurences]
        je corect
        
        push dword[n]
        push dword[c]
        push dword outputformat1
        call [printf]
        add esp,4*3
        jmp final
        
        corect:
        push dword[n]
        push dword[c]
        push dword outputformat2
        call [printf]
        add esp,4*3
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
