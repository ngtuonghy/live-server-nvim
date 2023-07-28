local M = {}
Default_config = {
	serverpath = vim.fn.stdpath("data") .. "live-server",
}
--
-- M.install = function()
-- 	local path_liveserver = Default_config.path_install
-- end
M.start = function()
	local realPath = vim.fn.expand("%:p") -- duong dan tuyệt doi
	local cmd = { "npm", "x", "--prefix", Default_config.serverpath, "live-server", realPath }
	SERVER_JOB = vim.fn.jobstart(vim.tbl_flatten(cmd), {
		on_stdout = function(channel_id, data, name)
			local out = string.gsub(data[1], "[[^\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
			print(out)
		end,
	})
	print("Started live-server!")
end

return M
