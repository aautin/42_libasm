; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;

LIST_DATA	equ 0
LIST_NEXT	equ 8

; void	ft_list_remove_if(t_list** list, void *data_ref, int (*cmp)())

START equ 0x8
DATA equ 0x10
COMP equ 0x18
PREV equ 0x20
CURR equ 0x28

section .text
global ft_list_remove_if

ft_list_remove_if:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x28

	; local variables initialisation
	mov		qword [rbp - START], rdi
	mov		qword [rbp - DATA], rsi
	mov		qword [rbp - COMP], rdx
	mov		qword [rbp - PREV], 0
	mov		rdi, qword [rdi]
	mov		qword [rbp - CURR], rdi

.loop:
	; loop while CURR != NULL
	cmp		qword [rbp - CURR], 0
	je		.end

	; compare CURR data with data
	mov		rdi, qword [rbp - DATA]
	mov		rsi, qword [rbp - CURR]
	mov 	rsi, qword [rsi + LIST_DATA]
	call	qword [rbp - COMP]

	; remove only if datas are equal
	cmp		rax, 0
	jne		.loop_end

	cmp		qword [rbp - PREV], 0
	jne		.remove
	jmp		.remove_first

.remove:
	; CURR = CURR->NEXT
	mov		rdi, qword [rbp - CURR]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		qword [rbp - CURR], rdi

	; PREV->NEXT = CURR
	mov		rdi, qword [rbp - CURR]
	mov		rsi, qword [rbp - PREV]
	mov		qword [rsi + LIST_NEXT], rdi

	; here I can free CURR

	jmp		.loop

.remove_first:
	; START = CURR->NEXT
	mov		rdi, qword [rbp - START]
	mov		rsi, qword [rbp - CURR]
	mov		rsi, qword [rsi + LIST_NEXT]
	mov		qword [rdi], rsi

	; here I can free CURR

	; CURR = CURR->NEXT
	mov		rdi, qword [rbp - CURR]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		qword [rbp - CURR], rdi

	jmp		.loop

.loop_end:
	; PREV = CURR
	mov		rdi, qword [rbp - CURR]
	mov 	qword [rbp - PREV], rdi

	; CURR = CURR->NEXT
	mov		rdi, qword [rbp - CURR]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		qword [rbp - CURR], rdi

	jmp		.loop

.end:
	xor		rax, rax
	leave
	ret
