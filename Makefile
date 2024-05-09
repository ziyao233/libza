#	libza
#	/Makefile
#	SPDX-License-Indentifier: MPL-2.0
#	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>

LIBZA		:= libza.a
OBJS		:= $(shell tools/zconfig.lua objs)

include rule.mk

.PHONY: default clean disbuild

default: $(LIBZA)

$(LIBZA): $(OBJS)
	$(AR) cr $(LIBZA) $(OBJS)

clean:
	-rm -f $(OBJS)

disbuild: clean
	-rm -f $(LIBZA)
