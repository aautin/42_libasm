extern printf
extern __errno_location
extern free

extern ft_strlen
extern ft_strcmp
extern ft_strcpy
extern ft_strdup
extern ft_read
extern ft_write


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


section .bss
string6:
	resb 100


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
	sub		rsp, 0x10
	mov		qword [rbp - 0x10], rax

	cmp		qword [rbp - 0x10], 0
	je		.dup_failure
	jmp		.dup_success

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

	add		rsp, 0x8
	jmp		.dup_then

.dup_success:
	mov		byte [rel string5 + 0x2], 'X'

	mov		rdi, strdup_format
	mov		rsi, string5
	mov		rdx, string5
	mov		rcx, qword [rbp - 0x10]
	mov		r8, qword [rbp - 0x10]
	mov		r9, printf
	xor		rax, rax
	call	r9

	xor		rsi, rsi
	xor		rdx, rdx
	xor		rcx, rcx
	xor		r8, r8
	xor		r9, r9
	mov		rdi, qword [rbp - 0x10]
	mov		r11, free
	call	r11

.dup_then:
	; ------ STRDUP ------


	; ------ READ ------
	mov		rsi, string6
	mov		qword [rbp - 0x8], rsi

	mov		rdi, 0
	mov		rdx, 99
	call	ft_read

	cmp		rax, 0
	jl		.done

	mov		rsi, qword [rbp - 0x8]
	mov		byte [rsi + rax], 0
	mov		qword [rbp - 0x10], rax
	; ------ READ ------


	; ------ WRITE ------
	inc		rax
	sub		rsp, rax

	mov		r10, rbp
	sub		r10, rax
	sub		r10, 0x10
	mov		rdi, r10
	mov		rsi, qword [rbp - 0x8]
	call	ft_strcpy

	mov		rdi, 1
	mov		rsi, rax
	mov		rdx, qword [rbp - 0x10]
	call	ft_write
	; ------ WRITE ------


.done:
	xor rax, rax
	leave
	ret
