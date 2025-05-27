extern printf
extern ft_strlen
extern ft_strcmp
extern ft_strcpy

section .data
string1:
	db "ABCDE", 0x0
string2:
	db "ABCD", 0x0
string3:
	times 100 db 0x0
string4:
	db "Content", 0x0

strlen_format:
	db "(STRLEN)", 0xA, "lenght of '%s': %lu", 0xA, 0xA, 0x0
strcmp_format:
	db "(STRCMP)", 0xA, "diff between '%s' and '%s': %d", 0xA, 0xA, 0x0
strcpy_format1:
	db "(STRCPY)", 0xA, "'%s' || '%s'", 0xA, 0x0
strcpy_format2:
	db "[COPYING]", 0xA, "'%s' || '%s' || '%s'", 0xA, 0xA, 0x0

section .text
global main

main:
	push	rbp
	mov		rbp, rsp


	; ------ STRLEN ------
	mov		rdi, string1
	call	ft_strlen

	mov		rdi, strlen_format
	mov		rsi, string1
	mov		rdx, rax
	mov		rax, printf
	call	rax
	; ------ STRLEN ------


	; ------ STRCMP ------
	mov		rdi, string1
	mov		rsi, string2
	call	ft_strcmp

	mov		rdi, strcmp_format
	mov		rsi, string1
	mov		rdx, string2
	mov		rcx, rax
	mov		rax, printf
	call	rax
	; ------ STRCMP ------


	; ------ STRCPY ------
	mov		rdi, strcpy_format1
	mov		rsi, string3
	mov		rdx, string4
	mov		rax, printf
	call	rax

	mov		rdi, string3
	mov		rsi, string4
	call	ft_strcpy

	mov		rdi, strcpy_format2
	mov		rsi, string3
	mov		rdx, string4
	mov		rcx, rax
	mov		rax, printf
	call	rax
	; ------ STRCPY ------

	xor eax, eax
	leave
	ret
