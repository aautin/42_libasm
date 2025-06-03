#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "libasm.h"

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
	if (argc < 3)
		return (0);

	t_list*	list = NULL;

	for (int i = argc - 1; i > 2; --i) {
		t_list*	new = ft_list_new(strdup(argv[i]));
		ft_list_push_front(&list, new);
	}

	printf("list size: %d\n", ft_list_size(list));

	t_list* ptr = list;
	for (int i = 0; ptr != NULL; ++i) {
		char* data = (char*)ptr->data;
		printf("[%d] '%s'\n", i, data);
		ptr = ptr->next;
	}
	
	char *data = argv[1];
	printf("(Remove if '%s')\n", data);
	ft_list_remove_if(&list, data, (int (*)(void*, void*))strcmp, &free);
	
	ptr = list;
	for (int i = 0; ptr != NULL; ++i) {
		char* data = (char*)ptr->data;
		int	res = ft_atoi_base(data, argv[2]);
		printf("[%d] '%s', %d from base\n", i, data, res);
		ptr = ptr->next;
	}

	ft_list_sort(&list, (int (*)(void*, void*))strcmp);
	printf("(Bubble Sort)\n");

	for (int i = 0; list != NULL; ++i) {
		printf("[%d] '%s'\n", i, (char*)list->data);
		list = ft_list_delone(list);
	}

	return (0);
}
