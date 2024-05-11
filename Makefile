#	libza
#	/Makefile
#	SPDX-License-Indentifier: MPL-2.0
#	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>

LIBZA		:= libza.a
OBJS		:= $(shell tools/zconfig.lua objs)
SRCS		:= $(patsubst %.o,%.c,$(OBJS))
DEPS		:= $(patsubst %.o,%.d,$(OBJS))

include rule.mk

.PHONY: default clean disbuild updateconfig

default: $(LIBZA) updateconfig

updateconfig: include/za/config.h

include/za/config.h: config.lua
	echo "#ifndef __ZA_CONFIG_H_INC__" > $@
	tools/zconfig.lua gendefs >> $@
	echo "#endif // __ZA_CONFIG_H_INC__" >> $@

$(LIBZA): $(OBJS) $(DEPS)
	$(AR) cr $(LIBZA) $(OBJS)

clean:
	-rm -f $(OBJS)
	-rm -f $(DEPS)

disbuild: clean
	-rm -f $(LIBZA)
	-rm -f include/za/config.h

%.d: %.c
	$(CC) -MM $< -MF $@ $(CFLAGS)

ifeq (0,$(words $(findstring $(MAKEFLAGGOALS), disbuild clean)))
include $(DEPS)
endif
