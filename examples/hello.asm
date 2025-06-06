; fasm demonstration of writing simple ELF executable

format ELF executable 3
entry start

segment readable executable

start:

	mov	eax, 4
	mov	ebx, 1
	mov	ecx, msg
	mov	edx, msg_size
	syscall

	mov	eax, 1
	xor	ebx, ebx
	syscall

segment readable writeable

msg db 'Hello world!', 0xA
msg_size = $-msg
