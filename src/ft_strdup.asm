extern malloc
extern set_errno

extern ft_strlen
extern ft_strcpy

section .text
global ft_strdup

ft_strdup:
	push	rbp
	mov		rbp, rsp
	
	sub		rsp, 0x10
	mov		[rbp - 0x10], rdi

	call	ft_strlen

	inc		rax
	mov		rdi, rax
	mov		rax, malloc
	call	rax

	mov		r10, rax

	cmp		rax, 0
	je		.error

	mov		rdi, r10
	mov		rsi, [rbp - 0x10]
	call	ft_strcpy

	mov		rax, r10
	leave
	ret

.error:
	mov		rdi, 12
	call	set_errno

	mov		rax, 0
	leave
	ret
