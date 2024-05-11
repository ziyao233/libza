#ifndef __ZA_IO_H_INC__
#define __ZA_IO_H_INC__

#include<stdint.h>

#define writeb(addr, b)		*(volatile uint8_t *)(addr) = (b)
#define readb(addr)		*(volatile uint8_t *)(addr)
#define writes(addr, s)		*(volatile uint16_t *)(addr) = (s)
#define reads(addr)		*(volatile uint16_t *)(addr)
#define writel(addr, l)		*(volatile uint32_t *)(addr) = (l)
#define readl(addr)		*(volatile uint32_t *)(addr)

#endif	// __ZA_IO_H_INC__
