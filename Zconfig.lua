configs = {};

configs.lib = {
	depends = { "hello" },
	objs = { "lib.o" },
};

configs.hello = {
	objs = { "hello.o" }
};

return configs;
