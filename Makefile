#
# MinilibX Makefile
#

MLX_HEADER = mlx.h
MLX_NAME   = libmlx.a

DOC_DIR   = pdf
TROFF_DIR = man
MAN_PAGES = $(wildcard $(TROFF_DIR)/*.3)
PDF_PAGES = $(MAN_PAGES:$(TROFF_DIR)/%.3=$(DOC_DIR)/%.pdf)

GENERATED_VARIABLES = libmlx.mk
include $(GENERATED_VARIABLES)

CC  ?= gcc
SRC  = $(wildcard $(MLX_FOLDER)/*.c)
SRCM = $(wildcard $(MLX_FOLDER)/*.m)
OBJ  = $(SRC:.c=.o) $(SRCM:.m=.o)

CFLAGS ?= -g -O2

TEST_DIR = test
TEST_EXE = test_mlx.exe

lib: $(MLX_NAME) $(MLX_HEADER)

doc: $(PDF_PAGES)

test: $(TEST_DIR)/$(TEST_EXE)

all: doc test

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(MLX_NAME) $(MLX_HEADER) $(TEST_DIR)/$(TEST_EXE)
	$(RM) -r $(DOC_DIR)

re: fclean
	@$(MAKE) all --no-print-directory


$(GENERATED_VARIABLES):
	$(error "You should run ./configure once")

$(MLX_NAME): $(OBJ)
	$(AR) rcs $@ $^

$(DOC_DIR)/%.pdf: $(TROFF_DIR)/%.3 | $(DOC_DIR)
	man -t $< | ps2pdf - $@

$(DOC_DIR):
	mkdir -p $@

$(MLX_HEADER): $(MLX_FOLDER)/$(MLX_HEADER)
	ln -s $< $@

$(TEST_DIR)/$(TEST_EXE): lib
	$(CC) $(CFLAGS) $(CPPFLAGS) -I. $(@D)/main.c -o $@ -L. -lmlx $(LDLIBS)

.PHONY: all lib clean fclean re pdf test
