#include <stdlib.h>
#include <ctype.h>

int	get_index(char* base, char letter)
{
	int i = 0;
	while (base[i] != 0)
	{
		if (base[i] == letter)
			return i;
		i++;
	}
	return -1;
}

int ft_atoi_base(char* str, int base_length)
{
	char base[] = "0123456789abcdef";
	
	if (base_length < 0 || base_length > 16)
		return 0;

	base[base_length] = '\0';

	int	result = 0;
	int	sign = 1;

	while (isspace(*str))
		str++;

	if (*str == '-')
	{
		sign = -1;
		str++;
	}

	while (*str != 0)
	{
		int base_i = get_index(base, *str);
		if (base_i == -1)
			break;

		result *= base_length;
		result += base_i;
		str++;
	}

	return result * sign;
}
