section .text
global ft_strcpy

ft_strcpy:
	push	rbp
	mov		rbp, rsp

	push	rdi

.loop:
	mov		al, byte [rsi]
	mov		byte [rdi], al

	cmp		al, 0
	je		.done

	inc		rsi
	inc		rdi
	jmp		.loop

.done:
	pop		rdi

	mov		rax, rdi
	leave
	ret
