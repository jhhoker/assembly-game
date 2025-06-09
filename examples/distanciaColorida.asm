format ELF64 executable 
entry _start                  

segment readable writeable

numeroX dq 0        ; numeroX

; ---- Códigos ANSI de cor (ESC[...m + byte 0) ----
color_red         db 27,'[31m',0             ; vermelho
color_red_len     =  $-color_red             ; tamanho em bytes

color_orange      db 27,'[38;5;208m',0       ; laranja
color_orange_len  =  $-color_orange

color_yellow      db 27,'[33m',0             ; amarelo
color_yellow_len  =  $-color_yellow

color_green       db 27,'[32m',0             ; verde
color_green_len   =  $-color_green

color_reset       db 27,'[0m',0              ; reset de cor
color_reset_len   =  $-color_reset

; ---- Mensagens de distância ----
msg_mto_longe     db 'Muito longe!',10,0     ; >25
msg_mto_longe_len =  $-msg_mto_longe

msg_longe         db 'Longe!',10,0           ; 11-24
msg_longe_len     =  $-msg_longe

msg_perto         db 'Perto!',10,0           ; 1-10
msg_perto_len     =  $-msg_perto

msg_ok            db 'Acertou!',10,0
msg_ok_len        =  $-msg_ok

; ---- Buffer de entrada (3 dígitos + '\n') ----
input_buffer      rb 4        ; reserva 4 bytes não inicializados

;===========  SEÇÃO DE CÓDIGO (pode executar)  ================
segment readable executable

;----------------  INÍCIO  ------------------------------------
_start:
    ; sys_read(0, input_buffer, 4)  ← lê chute como string
    mov rax, 0                  ; nº da syscall 0 = read
    mov rdi, 0                  ; stdin (fd 0)
    mov rsi, input_buffer       ; destino
    mov rdx, 4                  ; até 4 bytes
    syscall                     ; chama o kernel

    ; Converte string → inteiro
    mov rsi, input_buffer       ; ponteiro da string em RSI
    call atoi                   ; retorna valor em RAX
    mov r8,  rax                ; salva chute em R8 (backup)

    ; Carrega número-alvo em RBX
    mov rbx, [numeroX]           ; lê 8 bytes (0-99 válido)

    ; Testa se acertou de primeira
    cmp r8, rbx                 ; chute == alvo ?
    je  .acertou                ; se sim, pula para mensagem verde

    ; Calcula distância absoluta |chute - alvo|
    mov rcx, r8                 ; RCX = chute
    sub rcx, rbx                ; RCX = chute - alvo
    cmp rcx, 0
    jns .dist_ok                ; se já ≥0, tudo bem
    neg rcx                     ; senão inverte sinal
.dist_ok:

    ; Decide cor / mensagem pela distância
    cmp rcx, 25
    jg  .set_vermelho           ; >25 → vermelho
    cmp rcx, 10
    jg  .set_laranja            ; 11-24 → laranja
    jmp .set_amarelo            ; 1-10 → amarelo

;----- Configura vermelho + texto ---------------------------------
.set_vermelho:
    mov rsi, color_red          ; RSI = código cor
    mov rdx, color_red_len
    mov r9,  msg_mto_longe      ; R9 = texto “Muito longe!”
    mov r10, msg_mto_longe_len
    jmp .imprime_dica

;----- Configura laranja + texto ----------------------------------
.set_laranja:
    mov rsi, color_orange
    mov rdx, color_orange_len
    mov r9,  msg_longe
    mov r10, msg_longe_len
    jmp .imprime_dica

;----- Configura amarelo + texto ----------------------------------
.set_amarelo:
    mov rsi, color_yellow
    mov rdx, color_yellow_len
    mov r9,  msg_perto
    mov r10, msg_perto_len
;--- imprime cor + texto -----------------------------------------
.imprime_dica:
    mov rax, 1                  ; syscall 1 = write
    mov rdi, 1                  ; stdout
    syscall                     ; escreve código de cor

    mov rax, 1                  ; escreve mensagem de distância
    mov rdi, 1
    mov rsi, r9                 ; ponteiro para texto
    mov rdx, r10                ; tamanho do texto
    syscall

    ; Reseta cor
    mov rax, 1
    mov rdi, 1
    mov rsi, color_reset
    mov rdx, color_reset_len
    syscall
    jmp .fim                    ; encerra programa

;---------------- Acertou! (verde) --------------------------------
.acertou:
    mov rax, 1                  ; write verde
    mov rdi, 1
    mov rsi, color_green
    mov rdx, color_green_len
    syscall

    mov rax, 1                  ; write “Acertou!”
    mov rdi, 1
    mov rsi, msg_ok
    mov rdx, msg_ok_len
    syscall

    mov rax, 1                  ; reset cor
    mov rdi, 1
    mov rsi, color_reset
    mov rdx, color_reset_len
    syscall
    ; cai direto em .fim

;---------------- Saída ---------------------------------
.fim:
    mov rax, 60                 ; syscall 60 = exit
    xor rdi, rdi                ; código de saída 0
    syscall

;================= ROTINA atoi ===================================
; Entrada : RSI → string “nn\n”
; Saída   : RAX → inteiro
atoi:
    xor rax, rax                ; inicia acumulador em 0
.loop_atoi:
    mov dl, [rsi]               ; DL = caractere atual
    cmp dl, 10                  ; é '\n' (ASCII 10)?
    je  .ret_atoi               ; se sim, fim
    sub dl, '0'                 ; ASCII → valor 0-9
    movzx rdx, dl               ; expande para 64 bits
    imul rax, rax, 10           ; rax = rax * 10
    add  rax, rdx               ; soma dígito
    inc  rsi                    ; avança ponteiro
    jmp .loop_atoi
.ret_atoi:
    ret                         ; devolve valor em RAX
