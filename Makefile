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

all: $(MLX_NAME) $(MLX_HEADER)

$(MLX_NAME): $(MLX_LIB)
	ln -s $^ $@

$(MLX_HEADER): $(MLX_DIR)/$(MLX_HEADER)
	ln -s $^ $@

$(MLX_LIB):
	@$(MAKE) -C $(MLX_DIR) all --no-print-directory

clean:
	@$(MAKE) -C $(MLX_DIR) clean --no-print-directory

fclean:
	@$(MAKE) -C $(MLX_DIR) fclean --no-print-directory
	rm -f $(MLX_NAME) $(MLX_HEADER)

re: clean
	@$(MAKE) all --no-print-directory

.PHONY: all clean fclean re
