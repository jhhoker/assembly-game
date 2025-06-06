format ELF64 executable 3
entry _start

segment readable writable
    escolha rb 2

segment readable executable

_start:
    ; Mostrar boas-vindas e instruções
    mov rsi, bem_vindo
    call print_string

    mov rsi, instrucoes
    call print_string

    ; Mostrar regras
    mov rsi, regra1
    call print_string

    mov rsi, regra2
    call print_string

    mov rsi, regra3
    call print_string

    mov rsi, regra4
    call print_string

    mov rsi, regra5
    call print_string

    mov rsi, regra6
    call print_string

    mov rsi, regra7
    call print_string

    ; Mostrar dicas com cores
    mov rsi, cor_vermelho
    call print_string

    mov rsi, cor_laranja
    call print_string

    mov rsi, cor_amarelo
    call print_string

    ; Mostrar menu
    mov rsi, menu_opcao
    call print_string

    mov rsi, menu1
    call print_string

    mov rsi, menu2
    call print_string

.ler_opcao:
    ; Ler opção do usuário
    mov rax, 0      ; syscall read
    mov rdi, 0      ; stdin
    mov rsi, escolha
    mov rdx, 2
    syscall

    cmp byte [escolha], '1'
    je jogar

    cmp byte [escolha], '2'
    je sair

    jmp _start      ; Qualquer outra tecla, volta ao início

jogar:
    call limpar_tela
    mov rsi, pressione
    call print_string
    call esperar_tecla
    jmp fim

sair:
    call limpar_tela
    mov rsi, sair_msg
    call print_string
    jmp fim

fim:
    mov rax, 60     ; syscall exit
    xor rdi, rdi
    syscall

; -------------------------------
; Função: print_string
; Entrada: RSI = ponteiro para string terminada em 0
print_string:
    push rax
    push rdi
    push rdx
    xor rax, rax
.find_len:
    cmp byte [rsi + rax], 0
    je .done
    inc rax
    jmp .find_len
.done:
    mov rdx, rax        ; tamanho
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    syscall
    pop rdx
    pop rdi
    pop rax
    ret

; -------------------------------
; Função: limpar_tela (usa comando ANSI)
limpar_tela:
    mov rsi, limpar
    call print_string
    ret

; -------------------------------
; Função: esperar_tecla
esperar_tecla:
    mov rax, 0
    mov rdi, 0
    mov rsi, escolha
    mov rdx, 1
    syscall
    ret

segment readable writable

bem_vindo db "Seja bem-vindo ao jogo de adivinhacao da DAT :D", 10, 0
instrucoes db "Leia atentamente as instrucoes a seguir:", 10, 0

regra1 db "O jogo e uma competicao entre voce e outro jogador.", 10, 0
regra2 db "Cada um vai tentar adivinhar um numero secreto entre 0 e 99.", 10, 0
regra3 db "Os chutes acontecem de forma alternada: voce joga, depois o outro jogador.", 10, 0
regra4 db "Apos cada tentativa, sera mostrado se o numero secreto e maior ou menor que o chute.", 10, 0
regra5 db "Cada jogador tem 3 tentativas.", 10, 0
regra6 db "O jogo termina quando alguem acerta ou quando acabam as tentativas.", 10, 0
regra7 db "A distancia do chute sera mostrada com uma cor:", 10, 0

cor_vermelho db 27, '[31m', "> 25 -> Muito longe (vermelho)", 10, 27, '[0m', 0
cor_laranja db 27, '[33m', "11 a 24 -> Longe (laranja)", 10, 27, '[0m', 0
cor_amarelo db 27, '[93m', "1 a 10 -> Perto (amarelo)", 10, 27, '[0m', 0

menu_opcao db 10, "Selecione uma opcao:", 10, 0
menu1 db "1) Continuar e jogar!", 10, 0
menu2 db "2) Sair do jogo.", 10, 0

pressione db "Pressione qualquer tecla para sair...", 10, 0
sair_msg db "Ok, ate a proxima!", 10, 0
limpar db 27, '[2J', 27, '[H', 0
