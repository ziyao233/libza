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

return configs;
