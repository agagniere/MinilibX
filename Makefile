#
# MinilibX Makefile
#

# Folders
DOC_DIR       = pdf
TROFF_DIR     = man
MLX_FOLDER   ?= X11

# Files
TARGET_STATIC = libmlx.a
TARGET_SHARED = libmlx.so
SRC           = $(wildcard $(MLX_FOLDER)/*.c)
SRCM          = $(wildcard $(MLX_FOLDER)/*.m)
OBJ           = $(SRC:.c=.o) $(SRCM:.m=.o)
MAN_PAGES     = $(wildcard $(TROFF_DIR)/*.3)
PDF_PAGES     = $(MAN_PAGES:$(TROFF_DIR)/%.3=$(DOC_DIR)/%.pdf)

# Compiler
CC           ?= gcc
CFLAGS       += -Wno-unused-result

static: $(TARGET_STATIC)

shared: $(TARGET_SHARED)

doc: $(PDF_PAGES)

all: static shared doc

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(TARGET_SHARED) $(TARGET_STATIC)
	$(RM) -r $(DOC_DIR)

$(TARGET_STATIC): $(OBJ)
	$(AR) rcs $@ $^

$(TARGET_SHARED): $(OBJ)
	$(CC) -shared $(CFLAGS) $^ $(LDFLAGS) $(LDLIBS) -o $@

$(DOC_DIR)/%.pdf: $(TROFF_DIR)/%.3 | $(DOC_DIR)
	man -t $< | ps2pdf - $@

$(DOC_DIR):
	mkdir -p $@

.PHONY: static shared doc all clean fclean
