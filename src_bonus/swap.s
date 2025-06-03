; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;
; void	swap(t_list** HEAD, t_list* prev_left, t_list* prev_right)

LIST_DATA equ 0x0
LIST_NEXT equ 0x8

HEAD	equ 0x8
PREV	equ	0x10
LEFT	equ	0x18
RIGHT	equ	0x20
NEXT	equ	0x28

section .text
global swap

swap:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x28

	; local variables initialisation
	mov		qword [rbp - HEAD], rdi
	mov		qword [rbp - PREV], rsi
	mov		qword [rbp - LEFT], rdx
	mov		rdx, qword [rdx + LIST_NEXT]
	mov		qword [rbp - RIGHT], rdx
	mov		rdx, qword [rbp - RIGHT]
	mov		rdx, qword [rdx + LIST_NEXT]
	mov		qword [rbp - NEXT], rdx

	mov		rdi, qword [rbp - HEAD]
	mov		rsi, qword [rbp - LEFT]
	cmp		qword [rdi], rsi
	je		.beginning

; else operands are not the two first elements : PREV->NEXT = RIGHT
.not_beginning:
	mov		rdi, qword [rbp - PREV]
	mov		rsi, qword [rbp - RIGHT]
	mov		qword [rdi + LIST_NEXT], rsi

	jmp .swap

; if operands are the two first elements : HEAD = RIGHT
.beginning:
	mov		rdi, qword [rbp - RIGHT]
	mov		rsi, qword [rbp - HEAD]
	mov		qword [rsi], rdi

	jmp .swap

.swap:
	; RIGHT->NEXT = LEFT
	mov		rdi, qword [rbp - RIGHT]
	mov		rsi, qword [rbp - LEFT]
	mov		qword [rdi + LIST_NEXT], rsi
	; LEFT->NEXT = NEXT
	mov		rdi, qword [rbp - LEFT]
	mov		rsi, qword [rbp - NEXT]
	mov		qword [rdi + LIST_NEXT], rsi

.end:
	; restore stack
	leave
	ret
