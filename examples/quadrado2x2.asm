format ELF64 executable
entry start

segment readable executable
start:
    ; Primeira linha: vermelho, azul
    call print_red
    call print_blue
    call print_newline

    ; Segunda linha: azul, vermelho
    call print_blue
    call print_red
    call print_newline

    ; Sair do programa
    mov rax, 60
    xor rdi, rdi
    syscall

; -------------------------------
print_red:
    mov rax, 1
    mov rdi, 1
    mov rsi, fundo_vermelho
    mov rdx, fundo_vermelho_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, pixel
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, reset
    mov rdx, reset_len
    syscall
    ret

print_blue:
    mov rax, 1
    mov rdi, 1
    mov rsi, fundo_azul
    mov rdx, fundo_azul_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, pixel
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, reset
    mov rdx, reset_len
    syscall
    ret

print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    ret

; -------------------------------
segment readable writeable
fundo_vermelho     db 27, '[41m'       ; \x1b[41m
fundo_vermelho_len = $ - fundo_vermelho

fundo_azul         db 27, '[44m'       ; \x1b[44m
fundo_azul_len     = $ - fundo_azul

pixel              db ' '              ; bloco pintado (espaço com fundo colorido)

reset              db 27, '[0m'        ; reset
reset_len          = $ - reset

nl                 db 10               ; newline
