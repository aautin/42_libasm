section .data
string:
	db "My string has a length of 28", 0

section .text
extern strlen
global main

main:
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x8

	mov		rdi, string
	call	strlen

	mov		rdi, rax
	mov		rax, 0x3C
	syscall
