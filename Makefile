# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pbondoer <pbondoer@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/02/22 23:12:10 by pbondoer          #+#    #+#              #
#    Updated: 2017/02/03 02:44:22 by pbondoer         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

include libmlx.mk

MLX_HEADER=mlx.h

DOC_DIR=doc
MAN_PAGES=mlx mlx_loop mlx_new_image mlx_new_window mlx_pixel_put
PDF_PAGES=$(addprefix $(DOC_DIR)/,$(addsuffix .pdf,$(MAN_PAGES)))

all: $(MLX_NAME) $(MLX_HEADER)

pdf: $(PDF_PAGES)

$(MLX_NAME): $(MLX_LIB)
	ln -s $^ $@

$(MLX_HEADER): $(MLX_DIR)/$(MLX_HEADER)
	ln -s $^ $@

$(MLX_LIB):
	@$(MAKE) -C $(MLX_DIR) all --no-print-directory

$(DOC_DIR)/%.pdf: man/%.3 | doc
	man -t $< | ps2pdf - $@

doc:
	mkdir $@

clean:
	@$(MAKE) -C $(MLX_DIR) clean --no-print-directory

fclean:
	@$(MAKE) -C $(MLX_DIR) fclean --no-print-directory
	$(RM) $(MLX_NAME) $(MLX_HEADER)
	$(RM) -r $(DOC_DIR)

re: clean
	@$(MAKE) all --no-print-directory

.PHONY: all clean fclean re pdf
