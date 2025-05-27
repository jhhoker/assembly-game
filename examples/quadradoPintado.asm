format ELF64 executable
entry start

segment readable executable
start:
    ; Imprime o pixel vermelho
    call print_red

    ; Pula linha
    call print_newline

    ; Sair do programa
    mov rax, 60
    xor rdi, rdi
    syscall

; --------------------------------
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

print_newline:
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    ret

; --------------------------------
segment readable writeable
fundo_vermelho     db 27, '[41m'       ; \x1b[41m
fundo_vermelho_len = $ - fundo_vermelho

pixel              db ' '              ; espaço com fundo colorido

reset              db 27, '[0m'        ; reset de cor
reset_len          = $ - reset

nl                 db 10               ; newline
