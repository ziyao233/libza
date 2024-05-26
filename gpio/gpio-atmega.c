/*
 *	libza
 *	/gpio/gpio-atmega.c
 *	SPDX-License-Indentifier: MPL-2.0
 *	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>
 */

#include<za/config.h>
#include<za/memory.h>
#include<za/gpio.h>
#include<za/bitop.h>

#define GPIO_ADDR_START		(uint16_t)(ZCONFIG_ATMEGA_IOREG_OFFSET + 0x03)
#define REG(reg, port) \
	(*(volatile uint8_t *)(GPIO_ADDR_START + (port) * 3 + (reg)))
#define PIN			0
#define DDR			1
#define PORT			2

#define is_valid_pin(pin)	((pin) > 0 && (pin) < 24)

#define PIN_TO_PORT(pin)	((pin) >> 3)
#define PIN_TO_BIT(pin)		((pin) & 0x7)

void
za_gpio_conf(ZA_GPIO_Pin pin, int direction, int pull)
{
	unsigned int port = PIN_TO_PORT(pin);
	unsigned int bit  = PIN_TO_BIT(pin);
	if (!is_valid_pin(pin))
		return;

	if (direction == ZA_GPIO_OUTPUT) {
		za_bit_set(REG(DDR, port), bit);
	} else {
		za_bit_clr(REG(DDR, port), bit);
		if (pull == ZA_GPIO_PULLUP)
			za_bit_set(REG(PORT, port), bit);
		else
			za_bit_clr(REG(PORT, port), bit);
	}
	return;
}

void
za_gpio_write(ZA_GPIO_Pin pin, int value)
{
	if (!is_valid_pin(pin))
		return;

	if (value)
		za_bit_set(REG(PORT, PIN_TO_PORT(pin)), PIN_TO_BIT(pin));
	else
		za_bit_clr(REG(PORT, PIN_TO_PORT(pin)), PIN_TO_BIT(pin));

	return;
}

int
za_gpio_read(ZA_GPIO_Pin pin)
{
	return za_bit_getone(REG(PORT, PIN_TO_PORT(pin)), PIN_TO_BIT(pin));
}
