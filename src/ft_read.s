extern set_errno

section .text
global ft_read

ft_read:
	push	rbp
	mov		rbp, rsp

	mov		rax, 0x0
	syscall

	cmp		rax, 0
	jl		.error

	leave
	ret


.error:
	mov		rdi, 0
	sub		rdi, rax
	call	set_errno

	mov		rax, -1
	leave
	ret
