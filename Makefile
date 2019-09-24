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

all: $(MLX_NAME) mlx.h

$(MLX_NAME): $(MLX_LIB)
	ln -s $^ $@

mlx.h: $(MLX_DIR)/mlx.h
	ln -s $^ $@

$(MLX_LIB):
	@make -C $(MLX_DIR)

clean:
	rm -f $(MLX_NAME)
	@make -C $(MLX_DIR) clean

fclean: clean

re: clean
	@$(MAKE) all --no-print-directory
