#ifndef __ZA_GPIO_H_INC__
#define __ZA_GPIO_H_INC__

#include<stdint.h>

typedef uint16_t ZA_GPIO_Pin;
#define ZA_GPIO_INPUT		0
#define ZA_GPIO_OUTPUT		1

#define ZA_GPIO_NOPULL		0
#define ZA_GPIO_PULLUP		1
#define ZA_GPIO_PULLDOWN	2

void za_gpio_mux(ZA_GPIO_Pin pin, int direction, int pull);
void za_gpio_write(ZA_GPIO_Pin pin, int value);
int za_gpio_read(ZA_GPIO_Pin pin);

#endif	// __ZA_GPIO_H_INC__
