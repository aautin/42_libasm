section .text
global ft_read

ft_read:
	push	rbp
	mov		rbp, rsp

	mov		rax, 0x0
	syscall

	leave
	ret
