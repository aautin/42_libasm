section .text
global ft_strcmp

ft_strcmp:
	push	rbp
	mov		rbp, rsp

	xor		rcx, rcx

.loop:
	mov		al, byte [rdi + rcx]
	mov		bl, byte [rsi + rcx]
	cmp		al, bl
	jne		.done

	cmp		byte [rdi + rcx], 0
	je		.done

	inc		rcx
	jmp		.loop

.done:
	mov		al, byte [rdi + rcx]
	mov		bl, byte [rsi + rcx]
	movsx	rax, al
	movsx	rbx, bl

	sub		rax, rbx
	leave
	ret
