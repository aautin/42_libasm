extern __errno_location

section .text
global set_errno

set_errno:
	push	rbp
	mov		rbp, rsp

	mov		rsi, __errno_location
	call	rsi

	mov		dword [rax], 12

	leave
	ret
