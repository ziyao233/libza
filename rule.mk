#	libza
#	/rule.mk
#	SPDX-License-Identifier: MPL-2.0
#	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>

CROSS_COMPILE	?=
CC		:= $(CROSS_COMPILE)gcc
AR		:= $(CROSS_COMPILE)ar
OBJCOPY		:= $(CROSS_COMPILE)objcopy

CFLAGS		?=
CFLAGS		+= -funsigned-char -Iinclude -ffunction-sections
CFLAGS		+= -fdata-sections

%.o: %.c
	$(CC) $< -c $(CFLAGS) -o $@
