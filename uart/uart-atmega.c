/*
 *	libza
 *	/uart/uart-atmega.c
 *	SPDX-License-Identifier: MPL-2.0
 *	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>
 */

#include<za/config.h>
#include<za/memory.h>
#include<za/uart.h>

#ifndef CONFIG_SYSTEM_FREQ
	#error "Please set system_freq."
#endif

#define UCSRA			0xc0
#define UCSRB			0xc1
#define UCSRC			0xc2
#define UBRRL			0xc4
#define UBRRH			0xc5
#define UDR			0xc6

#define UDRE			(1 << 5)

void
za_uart_conf_baud(ZA_UART_Port port, uint32_t baudrate)
{
	(void)port;
	(void)baudrate;
	uint16_t ubbr = CONFIG_SYSTEM_FREQ / 16 / baudrate - 1;
	za_writeb(UBRRH, (ubbr >> 8) & 0x0f);
	za_writeb(UBRRL, ubbr & 0xff);
	return;
}

static volatile uint8_t dataBuf[32], bufRead, bufWrite;

void
za_uart_enable(ZA_UART_Port port)
{
	(void)port;
	bufRead = bufWrite = 0;
	za_writeb(UCSRA, 0);
	za_writeb(UCSRC, (0x3 << 1));	// UCSZn = 0x03, 8-bit
	za_writeb(UCSRB, (1 << 7) |	// RX Complete Interrupt enabled
			 (1 << 4) |	// Receiver Enabled
			 (1 << 3));	// Transmitter Enabled
	asm volatile ("sei");
	return;
}

void
za_uart_flush(ZA_UART_Port port)
{
	(void)port;
	while (!(za_readb(UCSRA) & UDRE))
		;
	return;
}

size_t
za_uart_read(ZA_UART_Port port, void *dst, size_t size)
{
	(void)port;
	while (bufRead == bufWrite)
		;

	uint8_t *p = dst;
	size_t i = 0;
	for (; i < size && bufRead != bufWrite; bufRead = (bufRead + 1) % 32) {
		p[i] = dataBuf[bufRead];
		i++;
	}

	return i;
}

void
za_uart_write(ZA_UART_Port port, const void *src, size_t size)
{
	(void)port;
	const uint8_t *p = src;
	for (size_t i = 0; i < size; i++) {
		while(!(za_readb(UCSRA) & UDRE))
			;
		za_writeb(UDR, p[i]);
	}
	return;
}

void __vector_18(void) __attribute__((__signal__, __used__));
void
__vector_18(void)
{
	uint8_t i = (bufWrite + 1) & 0x1f;
	uint8_t v = za_readb(UDR);
	if (i == bufRead)
		return;		// overflow

	dataBuf[bufWrite] = v;
	bufWrite = i;
}
