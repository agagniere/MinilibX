#
# MinilibX Makefile
#

MLX_HEADER=mlx.h
MLX_NAME=libmlx.a

DOC_DIR=doc
MAN_PAGES=mlx mlx_loop mlx_new_image mlx_new_window mlx_pixel_put
PDF_PAGES=$(addprefix $(DOC_DIR)/,$(addsuffix .pdf,$(MAN_PAGES)))

GENERATED_VARIABLES=libmlx.mk
include $(GENERATED_VARIABLES)

all: $(MLX_NAME) $(MLX_HEADER)

pdf: $(PDF_PAGES)

$(MLX_NAME): $(MLX_LIB)

$(GENERATED_VARIABLES):
	$(error "You should run ./configure once")

$(MLX_NAME): | $(MLX_FOLDER)/$(MLX_NAME)
	ln -s $| $@

$(MLX_HEADER): | $(MLX_FOLDER)/$(MLX_HEADER)
	ln -s $| $@

$(MLX_FOLDER)/$(MLX_NAME):
	@$(MAKE) -C $(MLX_FOLDER) all --no-print-directory

$(DOC_DIR)/%.pdf: man/%.3 | $(DOC_DIR)
	man -t $< | ps2pdf - $@

$(DOC_DIR):
	mkdir $@

clean:
	@$(MAKE) -C $(MLX_FOLDER) clean --no-print-directory

fclean:
	@$(MAKE) -C $(MLX_FOLDER) fclean --no-print-directory
	$(RM) $(MLX_NAME) $(MLX_HEADER)
	$(RM) -r $(DOC_DIR)

re: fclean
	@$(MAKE) all --no-print-directory

.PHONY: all clean fclean re pdf
