; typedef struct s_list
; {
; 	void			*data;
; 	struct s_list	*next;
; }	t_list;

; int	ft_list_size(t_list* list)

LIST_DATA equ 0
LIST_NEXT equ 8

section .text
global ft_list_size

ft_list_size:
	push	rbp
	mov		rbp, rsp

	sub		rsp, 0x8
	mov		qword [rbp - 0x8], rdi

	xor		ecx, ecx

	cmp		qword [rbp - 0x8], 0
	je		.done

	inc		ecx

.loop:
	mov		rdi, qword [rbp - 0x8]			; put -0x8 localvar value in rdi
	mov		rdi, qword [rdi + LIST_NEXT]	; offset rdi to LIST_DATA
	mov		qword [rbp - 0x8], rdi			; put next in -0x8 localvar

	cmp		qword [rbp - 0x8], 0
	je		.done

	inc		ecx
	jmp		.loop

.done:
	movsx		rax, ecx

	leave
	ret
