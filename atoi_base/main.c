#include <stdlib.h>
#include <stdio.h>

int ft_atoi_base(char* str, int base_length);

int	main(int argc, char** argv)
{
	if (argc != 3)
		return 0;

	char* str = argv[1];
	int	base_length = atoi(argv[2]);

	printf("%s (base %d) = %d (base 10)\n", str, base_length, ft_atoi_base(str, base_length));

	return 0;
}
