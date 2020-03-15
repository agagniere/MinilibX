/*
** mlx_loop.c for MiniLibX in
**
** Made by Charlie Root
** Login   <ol@epitech.net>
**
** Started on  Wed Aug  2 18:58:11 2000 Charlie Root
** Last update Fri Sep 30 14:47:41 2005 Olivier Crouzet
*/

#include "mlx_int.h"

#include <stdbool.h>

extern int (*(mlx_int_param_event[]))();

int mlx_loop(t_xvar* xvar)
{
	XEvent      ev;
	t_win_list* win;
	Atom wmDeleteMessage = XInternAtom(xvar->display, "WM_DELETE_WINDOW", False);
	bool keep_looping    = true;

	win = xvar->win_list;
	while (win)
	{
		XSetWMProtocols(xvar->display, win->window, &wmDeleteMessage, 1);
		win = win->next;
	}
	mlx_int_set_win_event_mask(xvar);
	xvar->do_flush = 0;
	while (keep_looping)
	{
		while (XPending(xvar->display))
		{
			XNextEvent(xvar->display, &ev);
			if (ev.type == ClientMessage && ev.xclient.data.l[0] == wmDeleteMessage)
			{
				keep_looping = false;
				break;
			}
			win = xvar->win_list;
			while (win && (win->window != ev.xany.window))
				win = win->next;
			if (win && ev.type < MLX_MAX_EVENT)
				if (win->hooks[ev.type].hook)
					mlx_int_param_event[ev.type](xvar, &ev, win);
		}
		if (xvar->loop_hook)
			xvar->loop_hook(xvar->loop_param);
	}
	XCloseDisplay(xvar->display);
	return (0);
}
