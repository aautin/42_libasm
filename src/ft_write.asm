section .text
global ft_write

ft_write:
	push	rbp
	mov		rbp, rsp

	mov		rax, 0x1
	syscall

	leave
	ret
