; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;

; void	ft_list_push_front(t_list** list, t_list* new)

LIST_DATA equ 0
LIST_NEXT equ 8

section .text
global ft_list_push_front

ft_list_push_front:
	push	rbp
	mov		rbp, rsp

	mov		rdx, qword [rdi]
	cmp		rdx, 0
	je		.no_list
	jmp		.list

.no_list:
	mov		qword [rdi], rsi

	jmp		.done

.list:
	mov		qword [rsi + LIST_NEXT], rdx
	mov		qword [rdi], rsi

	jmp		.done

.done:
	leave
	ret
