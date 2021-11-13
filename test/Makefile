# Files
EXEC  = test_mlx.exe
SRC   = main.c
OBJ   = $(SRC:.c=.o)

# Compiler
CC   ?= gcc

# ========== Conan ==========
CONAN_BUILD_INFO = conanbuildinfo.mak
include $(wildcard $(CONAN_BUILD_INFO))

CFLAGS   += $(CONAN_CFLAGS)
CPPFLAGS += $(addprefix -I, $(CONAN_INCLUDE_DIRS))
CPPFLAGS += $(addprefix -D, $(CONAN_DEFINES))
LDFLAGS  += $(addprefix -L, $(CONAN_LIB_DIRS))
LDLIBS   += $(addprefix -l, $(CONAN_LIBS))
LDLIBS   += $(addprefix -l, $(CONAN_SYSTEM_LIBS))
# ===========================


all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) $(LDLIBS) -o $@

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(EXEC)

.PHONY: all clean fclean
