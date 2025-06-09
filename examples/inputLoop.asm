format ELF64 executable 3
entry start

segment readable executable

start:
    mov r12, 3 ; Definindo quantidade de entradas
    mov r8l, 0 ; 0 = Jogador 1, 1 = Jogador 2

rounds_loop:
p1_turn:
    mov rsi, entry_msg
    call print_string

    mov rsi, p1
    call print_string
    call read_guess

    call treat_guess        

p2_turn:
    mov rsi, entry_msg
    call print_string

    mov rsi, p2
    call print_string
    call read_guess

    call treat_guess    
    
end_round:
    dec r12
    cmp r12, 0
    je exit
    jmp rounds_loop

exit:
    mov rax, 60
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
find_len:
    cmp byte [rsi + rax], 0
    je done
    inc rax
    jmp find_len
done:
    mov rdx, rax        ; tamanho
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    syscall
    pop rdx
    pop rdi
    pop rax
    ret

read_guess:
    ; Ler opção do usuário
    mov rax, 0      ; syscall read
    mov rdi, 0      ; stdin
    mov rsi, guess
    mov rdx, 2
    syscall

    xor rcx, rcx
    xor rbx, rbx

convert_loop:
    mov al, [guess + rcx]
    cmp al, 10
    je done_converting

    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rcx
    jmp convert_loop

done_converting:
    mov rcx, 0
    mov r13, rbx
    ret

treat_guess:
; Função: treat_guess
; Entrada: R8L = Jogador, R13 = Chute
    ret

segment writeable executable

entry_msg db "Informe seu chute, Jogador ", 0

p1 db "1: ", 0
p2 db "2: ", 0

guess rb 2
