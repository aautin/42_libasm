; int	ft_atoi_base(char* str, int base_length)

STRING		equ 0x8
BASE_LEN	equ 0xc
MINUS		equ 0x10
BASE		equ 0x18
RES			equ 0x20

extern str_index

section .data
base:
	db "0123456789abcdef", 0x0

section .text
global ft_atoi_base

ft_atoi_base:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x20

	; local variables initialisation
	mov		qword [rbp - STRING], rdi		; STRING = str
	mov		dword [rbp - BASE_LEN], esi		; BASE_LEN = base_length
	mov		byte [rbp - MINUS], 0			; MINUS = 0
	lea     rax, [rel base]
	mov		qword [rbp - BASE], rax			; BASE = base
	mov		dword [rbp - RES], 0			; RES = 0

	; return 0 if BASE_LEN is in [1, 16]
	cmp		dword [rbp - BASE_LEN], 1
	jl		.end
	cmp		dword [rbp - BASE_LEN], 16
	jg		.end

.spaces_loop:
	; if *STRING == 0
	mov		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0
	je		.end

	; if *STRING == ' ' : isspace
	cmp		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0x20
	je		.isspace

	; if *STRING < '\t' : not isspace
	cmp		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0x9
	jl		.minus

	; if *STRING > '\r' : not isspace
	cmp		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0xd
	jg		.minus

	jmp		.isspace

.isspace:
	inc		qword [rbp - STRING]
	jmp		.spaces_loop

.minus:
	; if *STRING != '-'
	mov		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0x2d
	jne		.loop

	; MINUS = 1 and STR++
	mov		byte [rbp - MINUS], 1
	inc		qword [rbp - STRING]

.loop:
	; while *str != 0
	mov		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0
	je		.end

	; str_index(BASE, BASE_LEN, *STR)
	mov		rdi, qword [rbp - BASE]
	mov		esi, dword [rbp - BASE_LEN]
	mov		rdx, qword [rbp - STRING]
	mov		dl, byte [rdx]
	call	str_index

	; if index == -1 : return RES
	cmp		eax, -1
	je		.end

	; RES *= RES
	mov		edi, dword [rbp - RES]
	mov		esi, dword [rbp - BASE_LEN]
	imul	edi, esi
	mov		dword [rbp - RES], edi

	; RES += INDEX
	add		dword [rbp - RES], eax

	; STRING++ then loop again
	inc		qword [rbp - STRING]
	jmp		.loop

.end:
	; set return value
	mov		eax, dword [rbp - RES]

	; optionally apply minus
	cmp		byte [rbp - MINUS], 1
	jne		.return
	imul    eax, eax, -1

.return:
	; restore stack
	leave
	ret
