; int	ft_atoi_base(char* str, char* base)

STRING		equ 0x8
BASE		equ 0x10
MINUS		equ 0x18
BASE_LEN	equ 0x20
RES			equ 0x28

extern str_index
extern ft_strlen

data:
	db "0123456789abcdef", 0x0
map:
	TIMES 255 db 0x0

section .text
global ft_atoi_base

ft_atoi_base:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x28

	; local variables initialisation
	mov		qword [rbp - STRING], rdi		; STRING = str
	mov		qword [rbp - BASE], rsi			; BASE = base
	mov		byte [rbp - MINUS], 0			; MINUS = 0
	mov		rdi, qword [rbp - BASE]
	call	ft_strlen
	mov		dword [rbp - BASE_LEN], eax		; BASE_LEN = ft_strlen(BASE)
	mov		dword [rbp - RES], 0			; RES = 0

	; return 0 if BASE_LEN is in [2, 16]
	cmp		dword [rbp - BASE_LEN], 2
	jl		.end

	; rdi is a pointer on the base
	mov		rdi, qword [rbp - BASE]

.check_base:
	; while not the end of the base -> keep going on parsing
	cmp		byte [rdi], 0
	je		.spaces_loop

	; if *base == '-' or *base == '+' or *base == ' ': return 0
	cmp		byte [rdi], 0x2d
	je		.end
	cmp		byte [rdi], 0x2b
	je		.end
	cmp		byte [rdi], 0x20
	je		.end

	; if *base is in the map, it's a duplicate : return 0
	; To be continued...
	; store *base in the map
	; To be continued...

	; if *base < '\t' or *base > '\r' : not isspace
	cmp		byte [rdi], 0x9
	jl		.check_base_end
	cmp		byte [rdi], 0xd
	jg		.check_base_end

	; otherwise, it's an isspace : return 0
	jmp		.end

.check_base_end:
	inc		rdi
	jmp		.check_base

.spaces_loop:
	; if *STRING == 0
	mov		rdi, qword [rbp - STRING]
	cmp		byte [rdi], 0
	je		.end

	; if *STRING == ' ' : isspace
	mov		rdi, qword [rbp - STRING]
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
