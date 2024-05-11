#!/usr/bin/env lua

--[[
--	libza
--	/tools/zconfig.lua
--	Configure tools for libza.
--	SPDX-License-Indentifier: MPL-2.0
--	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>
--]]

local io 	= require "io";
local string	= require "string";
local os	= require "os";

local function
perr(msg)
	io.stderr:write(msg .. '\n');
	os.exit(-1);
end

local function
perrf(fmt, ...)
	perr(string.format(fmt, ...));
end

local function
justDoFile(f)
	local handle, msg = io.open(f, "r");
	if not handle then
		perr(msg);
	end

	local loaded, msg = load(handle:read('a'), f, 't',
				 setmetatable({}, { __index = _G }));
	handle:close();
	if not loaded then
		perr(msg);
	end

	local ret, res = pcall(loaded);
	if not ret then
		perr(res);
	end

	return res;
end

--[[
--	configs = {
			[name: string] = {
				depends		= { "dep1", "dep2" },
				conflicts	= { "conflict1", "cnflict2" },
				kind		= "boolean" / "string" / "number",
				objs		= { "obj1.o", "obj2.o" },
				default		= ... ,
			},
		  }
--]]
local zdefs = justDoFile("Zconfig.lua");
if type(zdefs) ~= "table" then
	perrf("Invalid configs type, expect table, got %s", type(zdefs));
end

--[[		fix definition structure	]]--
for name, item in pairs(zdefs) do
	item.name = name;
	for i, dep in ipairs(item.depends or {}) do
		if not zdefs[dep] then
			perrf("entry `%s`: undefined dependency `%s`", name, dep);
		end
		item.depends[i] = zdefs[dep];
	end
	if not item.kind then
		item.kind = "boolean";	-- boolean value as default
	end
	if item.kind ~= "boolean" and item.objs then
		perrf("entry `%s`: a non-boolean entry with `objs` field",
		      name);
	end
	if item.objs and type(item.objs) ~= "table" then
		perrf("entry `%s`: got an `objs` field with type %s, " ..
		      "expect table", name, type(item.objs));
	end
end

--[[		check invalid dependencies		]]
for name, item in pairs(zdefs) do
	for i, dep in ipairs(item.depends or {}) do
		if dep.kind ~= "boolean" then
			perrf("entry %s: depends on a non-boolean entry %s",
			      name, dep.name);
		end
	end
end

local function
pusage(s)
	perrf("Usage:\n\tzconfig.lua %s", s);
end

local function
cmdDepends()
	if #arg ~= 2 then
		pusage "depends CONFIG";
	end
	local entry = zdefs[arg[2]];
	if not entry then
		perrf("Unknown config entry `%s`", arg[2]);
	end

	for _, dep in ipairs(entry.depends or {}) do
		io.write(dep.name .. " ");
	end
	io.write("\n");
end

local function
cmdObjs()
	if #arg == 1 then
		for _, entry in pairs(zdefs) do
			if entry.kind == "boolean" and entry.value then
				io.write(table.concat(entry.objs or {}, " "));
			end
			io.write(" ");
		end
		io.write('\n');
	else
		pusage "objs";
	end
end

local function
genDef(name, entry)
	local t = entry.kind;

	if not entry.value then
		return ("/* #undef %s */"):format(name);
	end

	if t == "boolean" then
		return ("#define CONFIG_%s 1"):format(name:upper());
	elseif t == "string" then
		return ("#define CONFIG_%s %s"):format(name:upper(), entry.value);
	elseif t == "number" then
		return ("#define CONFIG_%s %d"):format(name:upper(),
						       entry.value // 1);
	else
		error("Unexpected kind");
	end
end

local function
cmdGenDefs()
	if #arg == 1 then
		local defs = {};
		for name, entry in pairs(zdefs) do
			table.insert(defs, genDef(name, entry));
		end
		table.insert(defs, "");
		io.write(table.concat(defs, "\n"));
	else
		pusage "gendefs";
	end
end

local function
cmdDescribe()
	if #arg == 2 then
		local v = zdefs[arg[2]];
		if not v then
			perrf("entry `%s` undefined", arg[2]);
		else
			print(v.description or "(no description)");
		end
	else
		pusage "describe CONFIG";
	end
end

local commands = {
	depends		= { f = cmdDepends, noConfig = true },
	objs		= { f = cmdObjs },
	gendefs		= { f = cmdGenDefs },
	describe	= { f = cmdDescribe, noConfig = true },
};

local function
recursiveEnableDepends(item)
	for _, dep in ipairs(item.depends or {}) do
		if not dep.value then
			dep.value = true;
			recursiveEnableDepends(dep);
		end
	end
end

local function
resolveConfig()
	local rawCfgs = justDoFile("config.lua");
	if type(rawCfgs) ~= "table" then
		perrf("config.lua returns unexpected type %s, expect table",
		      type(rawCfgs));
	end

	for k, v in pairs(rawCfgs) do
		local e = zdefs[k];
		if not e then
			perrf("undefined config entry `%s` " ..
			      "referenced in config.lua", k);
		end

		if type(v) ~= e.kind then
			perrf("entry `%s`: kind mismatch in config.lua\n" ..
			      "expect %s, got %s", k, e.kind, type(v));
		end

		e.value = v;
	end

	--[[		Enable indirect dependencies	]]
	for _, entry in pairs(zdefs) do
		if entry.kind == "boolean" and entry.value == true then
			recursiveEnableDepends(entry);
		elseif entry.kind ~= "boolean" then
			if not entry.value then
				entry.value = entry.default;
			end
		end
	end
end

if #arg == 0 then
	os.exit(0);		-- simply checks Zconfigs
elseif commands[arg[1]] then
	if not commands[arg[1]].noConfig then
		resolveConfig();
	end

	commands[arg[1]].f();
else
	io.stderr:write(("Unknown command %s\n"):format(arg[1]));
	io.stderr:write("Available commands:\n");

	local cmdNames = {};
	for k, _ in pairs(commands) do
		table.insert(cmdNames, k);
	end
	table.sort(cmdNames);
	for _, n in ipairs(cmdNames) do
		print("\t" .. n);
	end
end
