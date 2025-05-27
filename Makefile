NAME=libasm.a

FILES=	ft_strlen \
		ft_strcpy \
		ft_strcmp \
		ft_write \
		ft_read \
		ft_strdup

MAIN_FILES=	main

SRC_DIR=src
SRC= $(addsuffix .asm, $(addprefix $(SRC_DIR)/, $(FILES)))

OBJ_DIR=obj
OBJ= $(addsuffix .o, $(addprefix $(OBJ_DIR)/, $(FILES)))

MAIN_SRC=$(SRC_DIR)/main.asm
MAIN_OBJ=$(OBJ_DIR)/main.o

TESTER=tester

CC= nasm
CFLAGS= -f elf64 -g -F dwarf

all: $(NAME)

$(NAME): $(OBJ_DIR) $(OBJ)
	ar rcs $@ $(OBJ)

$(OBJ_DIR):
	mkdir -p $@

obj/main.o: src/main.asm
	$(CC) $(CFLAGS) -o $@ $<

obj/%.o: src/%.asm
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)
	rm -rf $(TESTER)

re: fclean $(NAME)

$(TESTER): $(NAME) $(MAIN_OBJ)
	gcc -fPIE -pie -g -o $@ $(MAIN_OBJ) -L. -lasm
