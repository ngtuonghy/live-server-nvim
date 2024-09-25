local M = {}
local defaultConfig = {
	custom = {},
	serverPath = vim.fn.stdpath("data") .. "/live-server/",
	open = "folder", -- cwd
}

local function show_error_message(message)
	vim.notify(message, vim.log.levels.ERROR, { title = "live-server-nvim" })
end

local function show_warning_message(message)
	vim.notify(message, vim.log.levels.WARN, { title = "live-server-nvim" })
end

local function show_info_message(message)
	vim.notify(message, vim.log.levels.INFO, { title = "live-server-nvim" })
end

local function getOpen(is_file)
	local open = defaultConfig.open
	if open == "folder" then
		if is_file then
			return vim.fn.expand("%:p")
		end
		return vim.fn.expand("%:p:h")
	else
		show_warning_message(
			"Configured to serve from the current working directory(cwd) but requested to serve a file. "
				.. "Please adjust the configuration to use 'folder' mode for serving files."
				.. "Serving the current working directory(cwd) as fallback"
		)
		return vim.fn.getcwd()
	end
end

local function generateCommandListFromConfig()
	local cmdTable = { defaultConfig.serverPath .. "node_modules/.bin/live-server" }
	for _, option in pairs(defaultConfig.custom) do
		local cleanedValue = option:gsub("%s", "")
		table.insert(cmdTable, cleanedValue)
	end
	return cmdTable
end

local function removeAnsiEscapeSequences(inputString)
	local ansiEscapePattern = "\27%[%d;*%d*([mK])"
	local strippedString = inputString:gsub(ansiEscapePattern, "")
	return strippedString
end

local function onStdout(channel_id, data, name)
	local output = table.concat(data)
	local strippedOutput = removeAnsiEscapeSequences(output)
	if string.match(strippedOutput, "http") then
		show_info_message(strippedOutput)
	end
end

M.install = function()
	local serverPath = defaultConfig.serverPath
	show_info_message("Installing live-server to " .. serverPath)
	local installCmd = { "npm", "i", "live-server", "--prefix", serverPath }
	local stringInstallCmd = table.concat(installCmd, " ")
	vim.fn.jobstart(stringInstallCmd, {
		on_exit = function(_, code)
			if code == 0 then
				show_info_message("live-server has been installed at " .. serverPath)
			else
				show_error_message("Failed to install live-server. Try again!")
			end
		end,
	})
end

M.start = function(arg)
	local cmdTable = generateCommandListFromConfig()
	local serving_file = arg == "-f"
	local realPath = getOpen(serving_file)
	table.insert(cmdTable, realPath)
	local cmd_string = table.concat(cmdTable, " ")
	SESSION_JOB = vim.fn.jobstart(cmd_string, { on_stdout = onStdout })
end

M.stop = function()
	if SESSION_JOB == nil then
		show_info_message("live-server not running!")
	else
		vim.fn.jobstop(SESSION_JOB)
		SESSION_JOB = nil
		show_info_message("Stopped live-server!")
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
	defaultConfig = vim.tbl_deep_extend("force", defaultConfig, config)
end

vim.cmd("command! -nargs=? LiveServerStart lua require'live-server-nvim'.start(<f-args>)")
vim.cmd("command! LiveServerStop lua require'live-server-nvim'.stop()")
vim.cmd("command! LiveServerToggle lua require'live-server-nvim'.toggle()")
vim.cmd("command! LiveServerInstall  lua require'live-server-nvim'.install()")
return M
