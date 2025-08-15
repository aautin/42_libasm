; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;
; void	ft_list_sort(t_list** list, int (*cmp)())

LIST_DATA equ 0x0
LIST_NEXT equ 0x8

HEAD		equ 0x8
COMP		equ	0x10
SORTS_LEFT	equ	0x18
PREV_L		equ	0x20
PREV_R		equ	0x28

extern ft_list_size
extern swap

section .text
global ft_list_sort

ft_list_sort:
	; stack managment
	push	rbp
	mov		rbp, rsp
	sub		rsp, 0x28

	cmp 	rdi, 0
	je		.end
	cmp 	rsi, 0
	je		.end

	; local variables initialisation
	mov		qword [rbp - HEAD], rdi
	mov		qword [rbp - COMP], rsi
	mov		rdi, qword [rdi]
	mov		rsi, qword [rbp - COMP]
	call	ft_list_size
	mov		dword [rbp - SORTS_LEFT], eax

	; if ft_list_size < 2 : return 
	cmp		eax, 2
	jl		.end

.sort:
	dec		dword [rbp - SORTS_LEFT]

	; if SORTS_LEFT == 0 : return
	mov		edi, dword [rbp - SORTS_LEFT]
	cmp		edi, 0
	je		.end

	; PREV pointers initialisation
	mov		rdi, qword [rbp - HEAD]
	mov		rsi, qword [rdi]
	mov		qword [rbp - PREV_L], 0
	mov		qword [rbp - PREV_R], rsi

; sort_wave order the position of 1 element, must be executed ft_list_size() times
.sort_wave:
	; if right operand == 0 : finish this wave
	mov		rdi, qword [rbp - PREV_R]
	mov		rdi, qword [rdi + LIST_NEXT]
	cmp		rdi, 0
	je		.sort

	; put left operand in rdi, right operand in rsi
	mov		rdi, qword [rbp - PREV_R]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		rsi, qword [rbp - PREV_R]

	; save PREV_L and PREV_R->NEXT before potential swap
	mov		r12, qword [rbp - PREV_L]
	mov		r13, qword [rbp - PREV_R]
	mov		r13, qword [r13 + LIST_NEXT]

	; if cmp(left->data, right->data) <= 0 : don't swap
	mov		rdi, qword [rbp - PREV_R]
	mov		rdi, qword [rdi + LIST_DATA]
	mov		rsi, qword [rbp - PREV_R]
	mov		rsi, qword [rsi + LIST_NEXT]
	mov		rsi, qword [rsi + LIST_DATA]
	mov		rax, qword [rbp - COMP]
	call	rax
	cmp		eax, 0
	jle		.no_swap

.swap:
	; swap operands and update HEAD element if needed
	mov		rdi, qword [rbp - HEAD]
	mov		rsi, qword [rbp - PREV_L]
	mov		rdx, qword [rbp - PREV_R]
	call	swap

	; adjust the pointers : PREV_L = saved PREV_R, PREV_R doesn't change
	mov		qword [rbp - PREV_L], r13
	jmp		.sort_wave

.no_swap:
	; move pointer forward : PREV_L = PREV_R, PREV_R = PREV_R->LIST_NEXT
	mov		rdi, qword [rbp - PREV_R]
	mov		qword [rbp - PREV_L], rdi
	mov		rdi, qword [rbp - PREV_R]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		qword [rbp - PREV_R], rdi

	jmp		.sort_wave

.end:
	; restore stack
	leave
	ret
