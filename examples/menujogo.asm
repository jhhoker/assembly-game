format ELF64 executable
entry start

segment readable writeable
msg     db 'pressione 1 para Jogar', 10
msg_len = $ - msg
msg2 db 'pressione 0 para fechar', 10
msg2_len = $ - msg2
msg3 db 'encerrando...', 10
msg3_len =$ - msg3
msg4 db 'o jogo começou', 10
msg4_len = $ - msg4
msg5 db 10, 'input inválido! tente outro', 10, 10
msg5_len = $ - msg5
msg6 db 10, 'Regras do Jogo:', 10, \
            '-----------------------------------------------------------------', 10, \
            '• Será jogado por 2 pessoas.', 10, \
            '• Cada pessoa terá 3 tentativas para acertar o número.', 10, \
            '• O número-alvo estará entre 0 e 99.', 10, \
            '• O resultado poderá ser vitória ou empate.', 10, \
            '• Após uma Pessoa inserir um número e errar, deverá ser informada se o número a ser adivinhado é maior ou menor que o número inserido.', 10, \
            '• Deverá conter um sinal colorido informando a distância do número-alvo:', 10, \
            '    o Vermelho (muito longe)', 10, \
            '    o Laranja (longe)', 10, \
            '    o Amarelo (perto)', 10, \
            '    o Verde (acertou)', 10, \
            '• Após a vitória, deverá aparecer quem ganhou, Pessoa 1 ou Pessoa 2.', 10, 10
msg6_len = $ - msg6
msg7 db 10, 'jogador 1 faça sua tentativa: '
msg7_len = $ - msg7
msg8 db 10, 'jogador 2 faça sua tentatiava: '
msg8_len = $ - msg8

input_len equ 4;
inputBuffer rb input_len 

segment readable executable
start:
    mov     rax, 1; 
    mov     rdi, 1; 
    mov     rsi, msg6; 
    mov     rdx, msg6_len; 
    syscall  
menu:
    mov     rax, 1; 
    mov     rdi, 1; 
    mov     rsi, msg; 
    mov     rdx, msg_len; 
    syscall    
    
    mov     rax, 1; 
    mov     rdi, 1; 
    mov     rsi, msg2; 
    mov     rdx, msg2_len; 
    syscall; 

    ;ler o input do usuario
    mov  rax, 0; 
    mov  rdi, 0;
    mov  rsi, inputBuffer; 
    mov  rdx, input_len; 
    syscall

    mov  al, [rsi]

    cmp al, '0';
        je saida;

    cmp al, '1';
        je jogar;

    ;se nao for 0 nem 1
    invalido:
        mov     rax, 1; 
        mov     rdi, 1 ; 
        mov     rsi, msg5; 
        mov     rdx, msg5_len ;
        syscall 
        jmp menu;

    saida:
        mov     rax, 1; 
        mov     rdi, 1 ; 
        mov     rsi, msg3; 
        mov     rdx, msg3_len ;
        syscall 
        jmp encerrar;

    jogar:
        mov     rax, 1 ;
        mov     rdi, 1 ;
        mov     rsi, msg4 ; 
        mov     rdx, msg4_len ; 
        syscall

        mov bl, '0';

    jogador1:
        mov     rax, 1 ;
        mov     rdi, 1 ;
        mov     rsi, msg7 ; 
        mov     rdx, msg7_len ; 
        syscall

        mov  rax, 0; 
        mov  rdi, 0;
        mov  rsi, inputBuffer; 
        mov  rdx, input_len; 
        syscall

        mov ah, [rsi];
        ;aqui tem que ter o jump para a comparação, e a comparação deve ter um jump que leva para a label jogador2 ou um RET dependendo de como fizerem
        
    
    jogador2:
        xor ah, ah;

        mov     rax, 1 ;
        mov     rdi, 1 ;
        mov     rsi, msg8 ; 
        mov     rdx, msg8_len ; 
        syscall

        mov  rax, 0; 
        mov  rdi, 0;
        mov  rsi, inputBuffer; 
        mov  rdx, input_len; 
        syscall

        mov ah, [rsi];

        inc bl;
        cmp bl, '3';
            jne jogador1;
        
        
    encerrar:
        mov     rax, 60  ; 
        xor     rdi, rdi ; 
        syscall