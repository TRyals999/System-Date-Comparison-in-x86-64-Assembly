; Tyler Ryals
; Program: Compare the current systems date with user input

%include "io64.inc"

section .data
    askYear     db "Enter year (YYYY): ",0
    askMonth    db "Enter month (1-12): ",0
    outPrefix   db "The current year and month is ",0
    msgHigher   db " and your date is higher",0
    msgLowerEq  db " and your date is equal or lower",0

section .bss
    epochTime  resq 1          ; 64-bit space for epoch seconds
    userYear   resd 1
    userMonth  resd 1
    currYear   resd 1
    currMonth  resd 1
    inputBuf   resb 1      ; buffer for single char input

section .text
global main

main:
    mov rbp, rcx       ; SASM debugging fix

; Get current epoch time from OS using syscall

    ; syscall number for time is 201
    mov rax, 201
    lea rdi, [epochTime]     ; pointer to store result
    syscall

    ; Now move the epoch time into a register for conversion
    mov rax, [epochTime]

; Convert epoch seconds to approximate year and month
;    For accuracy, you'd need a more complex conversion.

    ; Divide seconds by number of seconds per year (approximate)
    ; seconds per year ≈ 365.2425 * 86400 ≈ 31,556,952
    ; For simplicity, use 31,556,952 as seconds per year
    mov rdi, 31556952
    xor rdx, rdx
    div rdi

    ; rax now contains the number of years since 1970
    ; Add 1970 to get the current year
    add rax, 1970
    mov [currYear], eax

    ; Remaining seconds after extracting years
    ; rdx contains remaining seconds
    mov rax, rdx     ; move remaining seconds
    ; Now get the current month
    ; seconds per month (approximate average) ≈ 2629746
    mov rdi, 2629746
    xor rdx, rdx
    div rdi
    ; rax now contains months since start of the year (0..11)
    ; Add 1 to match 1-12 months
    add rax, 1
    mov [currMonth], eax

; Input user’s year and month
    PRINT_STRING askYear
    NEWLINE
    call READ_INT64
    mov [userYear], eax

    PRINT_STRING askMonth
    NEWLINE
    call READ_INT64
    mov [userMonth], eax

; Output current date
    PRINT_STRING outPrefix
    mov eax, [currYear]
    PRINT_DEC 4, eax
    mov al, ' '
    PRINT_CHAR al
    mov eax, [currMonth]
    PRINT_DEC 2, eax
    NEWLINE

; Compare user input to current date
    mov eax, [userYear]
    mov ebx, [currYear]
    cmp eax, ebx
    jg userHigher
    jl userLowerEq
    mov eax, [userMonth]
    mov ebx, [currMonth]
    cmp eax, ebx
    jg userHigher

userLowerEq:
    PRINT_STRING msgLowerEq
    NEWLINE
    xor rax, rax
    ret

userHigher:
    PRINT_STRING msgHigher
    NEWLINE
    xor rax, rax
    ret

; 64-bit integer input routine using io64.inc macros

READ_INT64:
    push rbx
    xor rax, rax
    xor rbx, rbx
.read_loop:
    mov rdi, 0
    mov rsi, inputBuf
    mov rdx, 1
    mov rax, 0          ; read(0,buf,1)
    syscall
    cmp byte [inputBuf], 10  ; newline?
    je .done
    mov bl, [inputBuf]
    sub bl, '0'
    imul rax, rax, 10
    movzx rbx, bl
    add rax, rbx
    jmp .read_loop
.done:
    pop rbx
    ret

                ; stdin
         ; buffer
              ; read 1 byte
               ; syscall: read
  ; newline?
 
          ; load character
                 ; convert ASCII -> digit
              ; zero-extend digit
                 ; result += digit


