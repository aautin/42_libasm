; int	str_index(char* str, int str_len, char to_find)
; return -1 if not found
; str does't have to be null-terminated

STRING equ 0x8
STR_LEN equ 0x10
TO_FIND equ 0x14
INDEX equ 0x18

extern printf

section .data
format:
	db "%d\n", 0x0

section .text
global str_index

str_index:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x18

	; local variables initialisation
	mov		qword [rbp - STRING], rdi		; STRING = str
	mov		dword [rbp - STR_LEN], esi		; STR_LEN = str_len
	mov		byte [rbp - TO_FIND], dl		; TO_FIND = to_find
	mov		dword [rbp - INDEX], 0			; INDEX = 0

.loop:
	; while not INDEX >= STR_LEN
	mov		edi, dword [rbp - INDEX]
	mov		esi, dword [rbp - STR_LEN]
	cmp		edi, esi
	jge		.not_found

	; if STRING[INDEX] == TO_FIND : return INDEX
	mov		edi, dword [rbp - INDEX]		; edi = INDEX
	movsxd	rdi, edi						; edi extended to rdi
	mov		rsi, qword [rbp - STRING]
	mov		dl, byte [rsi + rdi]			; dl = STRING[INDEX]
	mov		dh, byte [rbp - TO_FIND]		; dh = TO_FIND
	cmp		dl, dh
	je		.found

	; if INDEX < 10 : don't check uppercase, loop again
	cmp		rdi, 10
	jl		.loop_end

	; if to_upper(STRING[INDEX]) == TO_FIND : it's found
	sub		dl, 'a' - 'A'
	cmp		dl, dh
	je		.found

.loop_end:
	; INDEX++ then loop again
	inc		dword [rbp - INDEX]
	jmp		.loop

.found:
	; set return value
	mov		eax, dword [rbp - INDEX]
	jmp		.end

.not_found:
	; set return value
	mov		eax, -1
	jmp		.end

.end:
	; printf return value
	; mov		rdi, format
	; mov		rsi, rax
	; mov		rax, printf
	; call	rax

	; restore stack
	leave
	ret
