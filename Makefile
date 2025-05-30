NAME=libasm.a
NAME_BONUS=libasm_bonus.a

FILES=	ft_strlen \
		ft_strcpy \
		ft_strcmp \
		ft_write \
		ft_read \
		ft_strdup \
		errno


FILES_BONUS=	ft_list_push_front \
				ft_list_remove_if \
				ft_list_size \
				ft_list_sort

MAIN_FILES=	main

SRC_DIR=src
SRC= $(addsuffix .asm, $(addprefix $(SRC_DIR)/, $(FILES)))
SRC_BONUS_DIR=src_bonus
SRC_BONUS= $(addsuffix .asm, $(addprefix $(SRC_BONUS_DIR)/, $(FILES_BONUS)))

OBJ_DIR=obj
OBJ= $(addsuffix .o, $(addprefix $(OBJ_DIR)/, $(FILES)))
OBJ_BONUS_DIR=obj_bonus
OBJ_BONUS= $(addsuffix .o, $(addprefix $(OBJ_BONUS_DIR)/, $(FILES_BONUS)))

MAIN_SRC=$(SRC_DIR)/main.asm
MAIN_OBJ=$(OBJ_DIR)/main.o
MAIN_BONUS_OBJ=$(OBJ_BONUS_DIR)/main.o

TESTER=tester
TESTER_BONUS=tester_bonus

CC= nasm
CFLAGS= -f elf64 -g -F dwarf

all: $(NAME)
bonus: $(NAME_BONUS)
.PHONY: all bonus clean fclean re

$(NAME): $(OBJ_DIR) $(OBJ)
	ar rcs $@ $(OBJ)
$(NAME_BONUS): $(OBJ_BONUS_DIR) $(OBJ_BONUS)
	ar rcs $@ $(OBJ_BONUS)

$(OBJ_DIR):
	mkdir -p $@
$(OBJ_BONUS_DIR):
	mkdir -p $@

obj/main.o: src/main.asm
	$(CC) $(CFLAGS) -o $@ $<
obj_bonus/main.o: src_bonus/main.c
	gcc -fPIE -pie -g -c $^ -o $@

obj/%.o: src/%.asm
	$(CC) $(CFLAGS) -o $@ $<
obj_bonus/%.o: src_bonus/%.asm
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf $(OBJ_DIR)
	rm -rf $(OBJ_BONUS_DIR)

fclean: clean
	rm -f $(NAME)
	rm -f $(NAME_BONUS)
	rm -f $(TESTER)
	rm -f $(TESTER_BONUS)

re: fclean $(NAME)

$(TESTER): $(NAME) $(MAIN_OBJ)
	gcc -z noexecstack-fPIE -pie -g -o $@ $(MAIN_OBJ) -L. -lasm

$(TESTER_BONUS): $(NAME_BONUS) $(MAIN_BONUS_OBJ)
	gcc -z noexecstack -fPIE -pie -g -o $@ $(MAIN_BONUS_OBJ) -L. -lasm_bonus
