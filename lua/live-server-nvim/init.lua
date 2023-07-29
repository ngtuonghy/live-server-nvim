local M = {}
Default_config = {
	custom = {},
	serverpath = vim.fn.stdpath("data") .. "/live-server/",
	open = "folder", -- cwd
}

local open = Default_config.open
local function getOpen()
	if open == "folder" then
		return vim.fn.expand("%:p:h")
	else
		return vim.fn.getcwd()
	end
end

local function readCustom(config)
	local cmd_table = { Default_config.serverpath .. "node_modules/.bin/live-server" }
	for _, option in pairs(config.custom) do
		local cleaned_value = option:gsub("%s", "")
		table.insert(cmd_table, cleaned_value)
	end
	return cmd_table
end
local cmd_table = readCustom(Default_config)

local function strip_ansi_escape_sequences(input_string)
	local ansi_escape_pattern = "\27%[%d;*%d*([mK])"
	local stripped_string = input_string:gsub(ansi_escape_pattern, "")
	return stripped_string
end

local function on_stdout(channel_id, data, name)
	local output = table.concat(data, "\n")
	local stripped_output = strip_ansi_escape_sequences(output)
	print(stripped_output)
end

local serverpath = Default_config.serverpath
M.install = function()
	print("Installing live-server to " .. serverpath)
	local install_cmd = { "npm", "i", "live-server", "--prefix", serverpath }
	local string_installcmd = table.concat(install_cmd, " ")
	vim.fn.jobstart(string_installcmd, {
		on_exit = function(_, code)
			if code == 0 then
				print("live-server has been installed at " .. serverpath)
			else
				error("Failed to install live-server.")
			end
		end,
	})
end

M.start = function()
	local realPath = getOpen()
	table.insert(cmd_table, realPath)
	local cmd_string = table.concat(cmd_table, " ")
	print(cmd_string)
	SESSION_JOB = vim.fn.jobstart(cmd_string, { on_stdout = on_stdout })
	print("live-server started")
end

M.stop = function()
	if SESSION_JOB == nil then
		print("live-server not running!")
	else
		vim.fn.jobstop(SESSION_JOB)
		SESSION_JOB = nil
		print("Stopped live-server!")
	end
end

M.toggle = function()
	if SESSION_JOB == nil then
		M.start()
	else
		M.stop()
	end
end

M.setup = function(config)
	Default_config = vim.tbl_deep_extend("force", Default_config, config)
	return Default_config
end

vim.cmd("command! LiveServerStart lua require'live-server-nvim'.start()")
vim.cmd("command! LiveServerStop lua require'live-server-nvim'.stop()")
vim.cmd("command! LiveServerToggle lua require'live-server-nvim'.toggle()")
vim.cmd("command! LiveServerInstall  lua require'live-server-nvim'.install()")
return M
