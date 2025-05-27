section .text
global strlen

strlen:
	push	rbp				; keep previous function rbp
	mov		rbp, rsp

	mov		rsi, rdi		; rsi = ptr to string
	xor		rcx, rcx		; rcx = counter

.loop:
	cmp		byte [rsi + rcx], 0
	je		.done
	inc		rcx
	jmp		.loop

.done:
	mov		rax, rcx
	leave
	ret
