extern printf
extern __errno_location
extern free

extern ft_strlen
extern ft_strcmp
extern ft_strcpy
extern ft_strdup

section .data
string1:
	db "ABCDE", 0x0
string2:
	db "ABCD", 0x0
string3:
	times 100 db 0x0
string4:
	db "Content", 0x0
string5:
	db "To be duplicated", 0x0

strlen_format:
	db "(STRLEN)", 0xA, "lenght of '%s': %lu", 0xA, 0xA, 0x0
strcmp_format:
	db "(STRCMP)", 0xA, "diff between '%s' and '%s': %d", 0xA, 0xA, 0x0
strcpy_format1:
	db "(STRCPY)", 0xA, "'%s' || '%s'", 0xA, 0x0
strcpy_format2:
	db "[COPYING]", 0xA, "'%s' || '%s' || '%s'", 0xA, 0xA, 0x0
strdup_format:
	db "%p:%s || %p:%s", 0xA, 0x0
strdup_format_error:
	db "errno:%u", 0xA, 0x0

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


	; ------ STRDUP ------
	mov		rdi, string5
	call	ft_strdup
	mov 	r10, rax

	cmp		r10, 0
	je		.dup_failure
	cmp		r10, 0
	jne		.dup_success

.dup_failure:

	sub		rsp, 0x8

	mov		rax, __errno_location
	call	rax

	mov     eax, dword [rax]
	mov		rsi, rax
	mov     rdi, strdup_format_error
	mov     rcx, printf
	xor		rax, rax
	call    rcx

	jmp		.dup_then

.dup_success:
	mov		byte [rel string5 + 0x2], 'X'

	mov		rdi, strdup_format
	mov		rsi, string5
	mov		rdx, string5
	mov		rcx, r10
	mov		r8, r10
	mov		rcx, printf
	xor		rax, rax
	call	rcx

	; xor		rsi, rsi
	; xor		rdx, rdx
	; xor		rcx, rcx
	; xor		r8, r8
	; xor		r9, r9
	; mov		rdi, r10
	; mov		r11, free
	; call	r11

.dup_then:
	; ------ STRDUP ------


	xor eax, eax
	leave
	ret
