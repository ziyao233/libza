configs = {};

configs.gpio = {
	description = "GPIO support",
};

configs.gpio_atmega = {
	depends		= { "gpio" },
	description	= "GPIO support for Atmega Devices",
	objs		= { "gpio/gpio-atmega.o" },
};

configs.atmega_ioreg_offset = {
	description = "Offset of IO registers on Atmega Devices",
	kind	    = "number",
	default	    = 0x20,
};

configs.system_freq = {
	description	= "System clock frequency",
	kind		= "number",
};

configs.uart = {
	description = "UART support",
};

configs.uart_atmega = {
	depends		= { "uart" },
	description	= "UART support for Atmega Devices",
	objs		= { "uart/uart-atmega.o" },
};

configs.cflags = {
	description	= "CFLAGS used for build libza",
	kind		= "string",
	default		= "",
};

return configs;
