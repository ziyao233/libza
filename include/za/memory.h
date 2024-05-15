/*
 *	libza
 *	/include/za/memory.h
 *	SPDX-License-Identifier: MPL-2.0
 *	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>
 */

#ifndef __ZA_IO_H_INC__
#define __ZA_IO_H_INC__

#include<stdint.h>

#define za_iomem		volatile

#define za_writeb(addr, b)	(*(volatile uint8_t *)(addr)) = (b)
#define za_readb(addr)		(*(volatile uint8_t *)(addr))
#define za_writes(addr, s)	(*(volatile uint16_t *)(addr)) = (s)
#define za_reads(addr)		(*(volatile uint16_t *)(addr))
#define za_writel(addr, l)	(*(volatile uint32_t *)(addr)) = (l)
#define za_readl(addr)		(*(volatile uint32_t *)(addr))

#endif	// __ZA_IO_H_INC__
