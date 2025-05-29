#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct		s_list
{
	void			*data;
	struct s_list	*next;
}					t_list;

// -------- BONUS FUNCS --------
void	ft_list_push_front(t_list** begin_list, void* data);
int 	ft_list_size(t_list *list);

/*
void 	ft_list_sort(t_list **begin_list, int (*cmp)());
void	ft_list_remove_if(t_list **begin_list, void *data_ref, 
		int (*cmp)(), void (*free_fct)(void *));
int		ft_atoi_base(char *str, char *base);
*/

static t_list*	ft_list_new(void* data)
{
	t_list* elem;

	if (!(elem = malloc(sizeof(*elem))))
		return (NULL);
	elem->data = data;
	elem->next = NULL;

	return (elem);
}

static t_list*	ft_list_delone(t_list*	element)
{
	t_list* next = element->next;

	free(element->data);
	free(element);

	return next;
}

int	main(int argc, char** argv)
{
	t_list*	list = NULL;

	for (int i = 1; i < argc; ++i) {
		t_list*	new = ft_list_new(strdup(argv[i]));
		ft_list_push_front(&list, new);
	}

	printf("list size: %d\n", ft_list_size(list));

	for (int i = 0; list != NULL; ++i) {
		printf("[%d] %s\n", i, (char*)list->data);
		list = ft_list_delone(list);
	}

	return (0);
}
