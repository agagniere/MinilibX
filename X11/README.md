This is the MinilibX, a simple X-Window (X11R6) programming API in C, designed for students, suitable for X-beginners.

# Contents
* source code in C to create the mlx library
* man pages (in man/ directory)
* a test program (in test/ directory)
* a public include file mlx.h

# Requirements
* MinilibX only support TrueColor visual type (8,15,16,24 or 32 bits depth)
* gcc
* X11 include files
* XShm extension must be present

# Install MinilibX
No installation script is provided. You may want to install
* `libmlx.a` and/or `libmlx_$(HOSTTYPE).a` in `/usr/X11/lib` or `/usr/local/lib`
* `mlx.h` in `/usr/X11/include` or `/usr/local/include`
* man pages in `/usr/X11/man/man3` or `/usr/local/man/man3`

Olivier CROUZET - 2014-01-06 -
