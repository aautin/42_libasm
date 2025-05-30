; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;

LIST_DATA equ 0x0
LIST_NEXT equ 0x8

; void	ft_list_sort(t_list** list, int (*cmp)())

extern ft_list_size

section .text
global ft_list_sort

ft_list_sort:
	push	rbp
	mov		rbp, rsp

	sub		rsp, 0x28					; (4 * 8) + (2 * 4) = 40 = 0x28
	mov		qword [rbp - 0x8], rdi		; t_list**	start_ptr
	mov		qword [rbp - 0x10], rsi		; int		(*cmp)()
	mov		rdi, [rdi]
	call	ft_list_size
	mov		dword [rbp - 0x14], eax - 1	; int		sorting_loops_nb

.sort_list:
	dec		dword [rbp - 0x14]

	cmp		dword [rbp - 0x14], 0
	jle		.done

	mov		dword [rbp - 0x18], 0		; set counter (i < sorting_loops_nb)
	mov		qword [rbp - 0x20], 0		; set first ptr (previous left operand)
	mov		rdi, qword [rbp - 0x8]
	mov		rdi, qword [rdi] 
	mov		qword [rbp - 0x28], rdi	; set second ptr (previous right operand)

.sort_element:
	mov		edi, dword [rbp - 0x18]
	cmp		edi, dword [rbp - 0x14]
	jge		.sort_list

	mov		rdi, qword [rbp - 0x28]
	mov		rdi, qword [rdi + LIST_DATA]	; set rdi on second ptr data

	mov		rsi, qword [rbp - 0x28]
	mov		rsi, qword [rsi + LIST_NEXT]
	mov		rsi, qword [rsi + LIST_DATA]	; set rsi on second ptr next data

	call	qword [rbp - 0x10]

	cmp		eax, 0
	jg		.swap

	; mov the 2 pointers forward
	mov		rsi, qword [rbp - 0x28]
	mov		rdi, qword [rbp - 0x20]
	mov		rdi, qword [rdi + LIST_NEXT]
	mov		rsi, qword [rsi + LIST_NEXT]

.sort_done:
	inc		dword [rbp - 0x18]
	jmp		.sort_element

.swap:
	; swap on the 2 first elements case
	cmp		qword [rbp - 0x20], 0
	cmove	rsi, qword [rbp - 0x28]
	cmove	rsi, qword [rsi + LIST_NEXT]
	cmove	rdi, qword [rbp - 0x8]
	mov		qword [rdi], rsi

	; save right operand next
	mov		rdx, qword [rbp - 0x28]
	mov		rdx, qword [rdx + LIST_NEXT]
	mov		rdx, qword [rdx + LIST_NEXT]

	; make right operand next point on left operand
	mov		rcx, qword [rbp - 0x28 + LIST_NEXT]
	cmp		rcx, 0
	cmovne		r12, qword [rbp - 0x28]
	cmovne		qword [rcx + LIST_NEXT], r12

	; make left operand next point on the saved right operand next
	mov		r13, qword [rbp - 0x28]
	mov		qword [r13 + LIST_NEXT], rdx

	; mov the 2 pointers forward
	mov		qword [rbp - 0x20], r12
	jmp		.sort_done

.done:
	leave
	ret
