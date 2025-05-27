format ELF64 executable
entry start

segment readable executable
start:
    ; Cor vermelha (31)
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, cor_vermelha
    mov     rdx, cor_vermelha_len
    syscall

    ; Mensagem colorida
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, mensagem
    mov     rdx, mensagem_len
    syscall

    ; Resetar cor
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, reset
    mov     rdx, reset_len
    syscall

    ; Finalizar programa
    mov     rax, 60
    xor     rdi, rdi
    syscall

segment readable writeable
cor_vermelha     db 27, '[31m'        ; \x1b[31m
cor_vermelha_len = $ - cor_vermelha

mensagem         db 'Texto em vermelho!', 10
mensagem_len     = $ - mensagem

reset            db 27, '[0m'         ; \x1b[0m
reset_len        = $ - reset
