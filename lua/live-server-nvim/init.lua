local M = {}
Default_config = {
	custom = {
		"--port=8080",
		"--quiet",
		"--no-css-inject",
	},
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
	local cmd_table = { "npx", "live-server" }
	for _, option in pairs(config.custom) do
		local cleaned_value = option:gsub("%s", "")
		table.insert(cmd_table, cleaned_value)
	end
	return cmd_table
end

-- Call the function with Default_config and realPath
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

local severpath = Default_config.serverpath
M.install = function()
	print("Installing live-server to " .. severpath)
	local install_cmd = { "npm", "i", "live-server", "--prefix", severpath }
	local string_installcmd = table.concat(install_cmd, " ")
	vim.fn.jobstart(string_installcmd, {
		on_exit = function(_, code)
			if code == 0 then
				print("live-server has been installed at " .. severpath)
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

M.setup = function(config)
	Default_config = vim.tbl_deep_extend("force", Default_config, config)
	return Default_config
end

vim.cmd("command! LiveSeverStart lua require'live-server-nvim'.start()")
vim.cmd("command! LiveSeverStop lua require'live-server-nvim'.stop()")
vim.cmd("command! LiveSeverInstall  lua require'live-server-nvim'.install()")
return M
