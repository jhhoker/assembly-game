format ELF64 executable
entry _start


segment readable writable

; --- Variáveis do Menu ---
escolha      rb 4
bem_vindo    db "Seja bem-vindo ao jogo de adivinhacao da DAT :D", 10, 0
instrucoes   db "Leia atentamente as instrucoes a seguir:", 10, 0
regra1       db "O jogo e uma competicao entre voce e outro jogador.", 10, 0
regra2       db "Cada um vai tentar adivinhar um numero secreto entre 0 e 99.", 10, 0
regra3       db "Os chutes acontecem de forma alternada: voce joga, depois o outro jogador.", 10, 0
regra4       db "Apos cada tentativa, sera mostrado se o numero secreto e maior ou menor que o chute.", 10, 0
regra5       db "Cada jogador tem 3 tentativas.", 10, 0
regra6       db "O jogo termina quando alguem acerta ou quando acabam as tentativas.", 10, 0
regra7       db "A distancia do chute sera mostrada com uma cor:", 10, 0
cor_vermelho db 27, '[31m', "> 25 -> Muito longe (vermelho)", 10, 27, '[0m', 0
cor_laranja  db 27, '[38;5;208m', "11 a 24 -> Longe (laranja)", 10, 27, '[0m', 0
cor_amarelo  db 27, '[33m', "1 a 10 -> Perto (amarelo)", 10, 27, '[0m', 0
menu_opcao   db 10, "Selecione uma opcao:", 10, 0
menu1        db "1) Continuar e jogar!", 10, 0
menu2        db "2) Sair do jogo.", 10, 0
numero       db "Digite o numero a ser adivinhado pelos jogadores (0-99): ", 0
sair_msg     db "Ok, ate a proxima!", 10, 0
limpar       db 27, '[2J', 27, '[H', 0

; --- Variáveis do Loop de Jogo ---
entry_msg db "Informe seu chute, Jogador ", 0
p1        db "1: ", 0
p2        db "2: ", 0
guess     rb 4

; --- Variáveis do Cálculo de Distância ---
color_red         db 27,'[31m',0
color_red_len     =  $-color_red
color_orange      db 27,'[38;5;208m',0
color_orange_len  =  $-color_orange
color_yellow      db 27,'[33m',0
color_yellow_len  =  $-color_yellow
color_green       db 27,'[32m',0
color_green_len   =  $-color_green
color_reset       db 27,'[0m',0
color_reset_len   =  $-color_reset
msg_mto_longe     db 'Muito longe!',10,0
msg_mto_longe_len =  $-msg_mto_longe
msg_longe         db 'Longe!',10,0
msg_longe_len     =  $-msg_longe
msg_perto         db 'Perto!',10,0
msg_perto_len     =  $-msg_perto
msg_ok            db 'Acertou!',10,0
msg_ok_len        =  $-msg_ok

; --- Variáveis de Controle ---
flag_acertou      rb 1
msg_vitoria1      db 10, "Jogador 1 venceu!", 10, 0
msg_vitoria2      db 10, "Jogador 2 venceu!", 10, 0
msg_sem_vencedor  db 10, "Fim de jogo. Ninguem acertou o numero.", 10, 0


; ==============================================================
; SEGMENTO DE CÓDIGO (EXECUTÁVEL)
; ==============================================================
segment readable executable

; --- Ponto de Entrada e Lógica do Menu Principal ---
_start:
    call limpar_tela
    mov rsi, bem_vindo
    call print_string
    mov rsi, instrucoes
    call print_string
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
    mov rsi, cor_vermelho
    call print_string
    mov rsi, cor_laranja
    call print_string
    mov rsi, cor_amarelo
    call print_string
    mov rsi, menu_opcao
    call print_string
    mov rsi, menu1
    call print_string
    mov rsi, menu2
    call print_string

.ler_opcao:
    mov rax, 0
    mov rdi, 0
    mov rsi, escolha
    mov rdx, 2
    syscall
    cmp byte [escolha], '1'
    je jogar
    cmp byte [escolha], '2'
    je sair
    jmp _start

jogar:
    call limpar_tela
    mov rsi, numero
    call print_string

    ; Ler o número secreto
    mov rax, 0
    mov rdi, 0
    mov rsi, escolha
    mov rdx, 4
    syscall
    mov rsi, escolha
    call atoi          ; Converte o número secreto para inteiro
    mov r15, rax       ; Guardamos o número secreto em R15 para uso global

    call limpar_tela
    call iniciar_loop_jogo ; << AQUI CHAMAMOS O LOOP PRINCIPAL DO JOGO

    ; O loop do jogo vai retornar para um dos pontos abaixo
    jmp fim            ; Se o loop terminar normalmente, vamos para o fim

jogador1_venceu:
    mov rsi, msg_vitoria1
    call print_string
    jmp fim

jogador2_venceu:
    mov rsi, msg_vitoria2
    call print_string
    jmp fim

fim_sem_vencedor:
    mov rsi, msg_sem_vencedor
    call print_string
    jmp fim

sair:
    call limpar_tela
    mov rsi, sair_msg
    call print_string
    jmp fim

fim:
    mov rax, 60
    xor rdi, rdi
    syscall

; -----------------------------------------------------------------
; --- LÓGICA DO LOOP DE JOGO (antes em loop_jogo.inc) ---
; -----------------------------------------------------------------
iniciar_loop_jogo:
    mov r12, 3 ; Definindo quantidade de rounds
    mov r8b, 0 ; 0 = Jogador 1, 1 = Jogador 2

rounds_loop:
    ; --- Turno do Jogador 1 ---
    mov rsi, entry_msg
    call print_string
    mov rsi, p1
    call print_string
    call read_guess
    call treat_guess
    cmp byte [flag_acertou], 1  ; Verifica se o jogador 1 ganhou
    je jogador1_venceu

    ; --- Turno do Jogador 2 ---
    mov rsi, entry_msg
    call print_string
    mov rsi, p2
    call print_string
    call read_guess
    call treat_guess
    cmp byte [flag_acertou], 1  ; Verifica se o jogador 2 ganhou
    je jogador2_venceu

    ; --- Fim da Rodada ---
    dec r12
    cmp r12, 0
    je fim_sem_vencedor 
    jmp rounds_loop

read_guess:
    mov rax, 0      
    mov rdi, 0      
    mov rsi, guess
    mov rdx, 4      
    syscall
    mov rsi, guess  
    call atoi       
    mov r13, rax    
    ret

treat_guess:

    mov rbx, r15                
    mov r8, r13                 
    call calcular_e_imprimir_distancia
    ret


; -----------------------------------------------------------------
; --- LÓGICA DE CÁLCULO DE DISTÂNCIA (antes em distancia.inc) ---
; -----------------------------------------------------------------
calcular_e_imprimir_distancia:
    mov byte [flag_acertou], 0 ; Reseta a flag de vitória no início de cada checagem

    cmp r8, rbx         ; chute == alvo ?
    je  .acertou

    ; Calcula distância absoluta |chute - alvo|
    mov rcx, r8
    sub rcx, rbx
    jns .dist_ok
    neg rcx
.dist_ok:
    cmp rcx, 25
    jg  .set_vermelho
    cmp rcx, 10
    jg  .set_laranja
    jmp .set_amarelo

.set_vermelho:
    mov rsi, color_red
    mov rdx, color_red_len
    mov r9,  msg_mto_longe
    mov r10, msg_mto_longe_len
    jmp .imprime_dica

.set_laranja:
    mov rsi, color_orange
    mov rdx, color_orange_len
    mov r9,  msg_longe
    mov r10, msg_longe_len
    jmp .imprime_dica

.set_amarelo:
    mov rsi, color_yellow
    mov rdx, color_yellow_len
    mov r9,  msg_perto
    mov r10, msg_perto_len

.imprime_dica:
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, r10
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, color_reset
    mov rdx, color_reset_len
    syscall
    ret

.acertou:
    mov byte [flag_acertou], 1 ; 
    mov rax, 1
    mov rdi, 1
    mov rsi, color_green
    mov rdx, color_green_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ok
    mov rdx, msg_ok_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, color_reset
    mov rdx, color_reset_len
    syscall
    ret


; -----------------------------------------------------------------
; --- FUNÇÕES UTILITÁRIAS ---
; -----------------------------------------------------------------
print_string:
    push rax
    push rdi
    push rdx
    push rcx
    xor rcx, rcx
.find_len:
    cmp byte [rsi + rcx], 0
    je .done
    inc rcx
    jmp .find_len
.done:
    mov rdx, rcx
    mov rax, 1
    mov rdi, 1
    syscall
    pop rcx
    pop rdx
    pop rdi
    pop rax
    ret

limpar_tela:
    mov rsi, limpar
    call print_string
    ret

atoi:
    xor  rax, rax
.loop_atoi:
    movzx rdx, byte [rsi]
    cmp  dl, 10
    je   .ret_atoi
    cmp  dl, '0'
    jb   .ret_atoi
    cmp  dl, '9'
    ja   .ret_atoi
    sub  dl, '0'
    imul rax, rax, 10
    add  rax, rdx
    inc  rsi
    jmp  .loop_atoi
.ret_atoi:
    ret