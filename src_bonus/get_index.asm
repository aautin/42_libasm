; int	str_index(char* str, int str_len, char to_find)
; return -1 if not found
; str does't have to be null-terminated

STR		equ 0x8		; [8->0[
STR_LEN	equ 0xa		; [10->8[
TO_FIND	equ	0xb		; [11->10[
INDEX	equ	0xf		; [15->11[

section .text
global str_index

str_index:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0xf

	; local variables initialisation
	mov		qword [rbp - STR], rdi			; STR = str
	mov		dword [rbp - STR_LEN], rsi		; STR_LEN = str_len
	mov		byte [rbp - TO_FIND], rdx		; TO_FIND = to_find
	mov		dword [rbp - INDEX], 0			; INDEX = 0

.loop:
	; while not INDEX >= STR_LEN
	mov		edi, dword [rbp - INDEX]
	mov		esi, dword [rbp - STR_LEN]
	cmp		edi, esi
	jge		.not_found

	; if STR[INDEX] == TO_FIND : return INDEX
	mov		edi, dword [rbp - INDEX]		; edi = INDEX
	mov		rsi, qword [rbp - STR]
	mov		dl, byte [rsi + edi]			; dl = STR[INDEX]
	mov		dh, byte [rbp - TO_FIND]		; dh = TO_FIND
	cmp		dl, dh
	je		.found

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
	; restore stack
	leave
	ret
