#ifndef LIBASM_H
# define LIBASM_H

typedef struct		s_list
{
	void			*data;
	struct s_list	*next;
}					t_list;

// mandatory functions
int		ft_read(int fd, char* buffer, size_t count);
int		ft_write(int fd, char* buffer, size_t count);
size_t	ft_strlen(char* str);
char*	ft_strcpy(char* dest, char* src);
int		ft_strcmp(char* s1, char* s2);
char*	ft_strdup(char* str);

// bonus functions
int		ft_atoi_base(char* str, int base_length);
void	ft_list_push_front(t_list** begin_list, void* data);
int		ft_list_size(t_list *list);
void	ft_list_sort(t_list **begin_list, int (*cmp)());
void	ft_list_remove_if(t_list **lst, void *ref, int (*cmp)(), void (*free)(void*));

#endif
