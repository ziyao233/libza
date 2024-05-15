/*
 *	libza
 *	/include/za/uart.h
 *	SPDX-License-Identifier: MPL-2.0
 *	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>
 */

#ifndef __ZA_UART_H_INC__
#define __ZA_UART_H_INC__

#include<stdint.h>
#include<stddef.h>

typedef uint8_t ZA_UART_Port;

void za_uart_conf_baud(ZA_UART_Port port, uint32_t baudrate);
void za_uart_enable(ZA_UART_Port port);
void za_uart_flush(ZA_UART_Port port);
size_t za_uart_read(ZA_UART_Port port, void *src, size_t size);
void za_uart_write(ZA_UART_Port port, const void *dst, size_t size);

#endif	// __ZA_UART_H_INC__
