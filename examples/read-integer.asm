format ELF64 executable 3
entry start

segment readable executable

start:
    
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 20
    syscall

    xor rbx, rbx
    xor rcx, rcx

convert_loop:
    mov al, [buffer + rcx]
    cmp al, 10
    je done_converting

    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rcx
    jmp convert_loop

done_converting:
    mov rcx, 0

reverse_digits:
    xor rdx, rdx
    mov rax, rbx
    mov r8, 10
    div r8
    add dl, '0'
    mov [int_str + rcx], dl
    inc rcx
    mov rbx, rax
    test rax, rax
    jnz reverse_digits

    mov rdi, rcx
    mov rsi, 0

reverse_string:
    dec rdi
    mov al, [int_str + rdi]
    mov [print_buf + rsi], al
    inc rsi
    test rdi, rdi
    jnz reverse_string

    mov byte [print_buf + rsi], 10
    inc rsi

print:
    mov rax, 1
    mov rdi, 1
    mov rdx, rsi
    mov rsi, print_buf
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

segment readable writeable

prompt db 'Digite um número: ', 0
prompt_len = $ - prompt

buffer rb 20
int_str rb 20
print_buf rb 20