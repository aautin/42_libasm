; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;
; void	ft_list_remove_if(t_list** list, void *data_ref, int (*cmp)())

LIST_DATA	equ 0
LIST_NEXT	equ 8

START equ 0x8
DATA equ 0x10
COMP equ 0x18
FREE equ 0x20
PREV equ 0x28
CURR equ 0x30

extern free

section .text
global ft_list_remove_if

ft_list_remove_if:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x30

	; local variables initialisation
	mov		qword [rbp - START], rdi
	mov		qword [rbp - DATA], rsi
	mov		qword [rbp - COMP], rdx
	mov		qword [rbp - FREE], rcx
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
	; PREV->NEXT = CURR->NEXT
	mov		rdi, qword [rbp - CURR]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		rsi, qword [rbp - PREV]
	mov		qword [rsi + LIST_NEXT], rdi

	; free CURR->DATA
	mov		rdi, qword [rbp - CURR]
	mov		rdi, qword [rdi + LIST_DATA]
	mov		rsi, qword [rbp - FREE]
	call	rsi
	; free CURR
	mov		rdi, qword [rbp - CURR]
	mov     rax, [rel free wrt ..got]
	call	rax

	; CURR = PREV->NEXT
	mov		rdi, qword [rbp - PREV]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		qword [rbp - CURR], rdi

	jmp		.loop

.remove_first:
	; START = CURR->NEXT
	mov		rdi, qword [rbp - START]
	mov		rsi, qword [rbp - CURR]
	mov		rsi, qword [rsi + LIST_NEXT]
	mov		qword [rdi], rsi

	; save CURR
	mov		r12, qword [rbp - CURR]

	; CURR = CURR->NEXT
	mov		rdi, qword [rbp - CURR]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		qword [rbp - CURR], rdi

	; free saved CURR->DATA
	mov		rdi, qword [r12 + LIST_DATA]
	mov		rsi, qword [rbp - FREE]
	call	rsi
	; free saved CURR
	mov		rdi, r12
	mov     rax, [rel free wrt ..got]
	call	rax

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
