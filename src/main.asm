extern ft_strlen
extern printf

section .data
string:
	db "Waouuuu", 0x0
strlen_printf:
	db "lenght of '%s': %d", 0xA, 0x0

section .text
global main

main:
	push	rbp
	mov		rbp, rsp

	; ------ STRLEN ------
	mov		rdi, string
	call	ft_strlen

	mov		rdi, strlen_printf
	mov		rsi, string
	mov		rdx, rax
	mov		rax, printf
	call	rax
	; ------ STRLEN ------

	xor eax, eax
	leave
	ret
