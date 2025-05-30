; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;
; void	ft_list_sort(t_list** list, int (*cmp)())

LIST_DATA equ 0x0
LIST_NEXT equ 0x8

extern ft_list_size

section .text
global ft_list_sort

ft_list_sort:
	push	rbp
	mov		rbp, rsp

	sub		rsp, 0x28					; (4 * 8) + (2 * 4) = 40 = 0x28
	mov		qword [rbp - 0x8], rdi		; t_list**	start_ptr
	mov		qword [rbp - 0x10], rsi		; int		(*cmp)()
	mov		rdi, qword [rdi]
	call	ft_list_size
	mov		dword [rbp - 0x14], eax		; int		sorting_loops_nb

.sort_list:
	dec		dword [rbp - 0x14]

	cmp		dword [rbp - 0x14], 0		; still sorting_loops to do ?
	jle		.done

	mov		dword [rbp - 0x18], 0		; set counter (i < sorting_loops_nb)
	mov		qword [rbp - 0x20], 0		; set first ptr (previous left operand)
	mov		rdi, qword [rbp - 0x8]
	mov		rdi, qword [rdi]
	mov		qword [rbp - 0x28], rdi		; set second ptr (previous right operand)

.sort_element:
    mov     edi, dword [rbp - 0x18]
    cmp     edi, dword [rbp - 0x14]
    jge     .sort_list

    ; Check if second_ptr->next == NULL
    mov     rax, qword [rbp - 0x28]
    mov     rax, qword [rax + LIST_NEXT]
    test    rax, rax
    je      .sort_list

    ; set rdi on second_ptr->data
    mov     rdi, qword [rbp - 0x28]
    mov     rdi, qword [rdi + LIST_DATA]

    ; set rsi on second_ptr->next->data
    mov     rsi, qword [rbp - 0x28]
    mov     rsi, qword [rsi + LIST_NEXT]
    mov     rsi, qword [rsi + LIST_DATA]

    call    qword [rbp - 0x10]

	cmp		eax, 0
	jg		.swap							; swap if second data greater than first


.sort_element_done:
	; mov the 2 pointers forward
	mov		rdi, qword [rbp - 0x28]
	mov		rsi, qword [rbp - 0x28]			; first ptr = second ptr
	mov		rsi, qword [rsi + LIST_NEXT]	; second ptr = second ptr -> next
	mov		qword [rbp - 0x20], rdi
	mov		qword [rbp - 0x28], rsi

	inc		dword [rbp - 0x18]
	jmp		.sort_element

.swap:
	cmp		qword [rbp - 0x20], 0
	jne		.swap_then

	; update list_ptr
	cmove	rsi, qword [rbp - 0x28]
	cmove	rsi, qword [rsi + LIST_NEXT]
	cmove	rdi, qword [rbp - 0x8]
	mov		qword [rdi], rsi

.swap_then:
	; save right operand next
	mov		rdx, qword [rbp - 0x28]
	mov		rdx, qword [rdx + LIST_NEXT]
	mov		rdx, qword [rdx + LIST_NEXT]

	; make right operand next point on left operand
	mov		rcx, qword [rbp - 0x28]
	mov		rcx, qword [rcx + LIST_NEXT]		; rcx is right operand
	mov		r12, qword [rbp - 0x28]				; r12 is left operand
	mov		qword [rcx + LIST_NEXT], r12

	; make left operand next point on the saved right operand next
	mov		r12, qword [rbp - 0x28]
	mov		qword [r12 + LIST_NEXT], rdx

.swap_then2:
	; mov the 2 pointers forward
	mov		qword [rbp - 0x20], r12
	jmp		.sort_element_done

.done:
	leave
	ret
