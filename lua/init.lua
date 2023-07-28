-- live_server.lua
local M = {}

local server_handle = nil
local server_port = 8080

function M.start_live_server()
	-- Khởi động máy chủ web bằng Node.js với gói npm "http-server"
	server_handle = vim.loop.spawn("http-server", {
		args = { "-p", tostring(server_port) },
		stdio = { nil, nil, nil },
	})

	-- In thông báo cho biết máy chủ đã được khởi động
	print("Live server đã khởi động tại http://localhost:" .. server_port)

	-- Mở URL trong trình duyệt mặc định
	vim.fn.jobstart("xdg-open http://localhost:" .. server_port, { detach = true })
end

function M.stop_live_server()
	-- Dừng máy chủ web bằng cách tắt tiến trình Node.js
	if server_handle then
		vim.loop.kill(server_handle, 9)
		server_handle = nil
		print("Live server đã dừng")
	end
end

-- Lắng nghe sự kiện khi lưu tệp tin, sau đó làm mới trang trong trình duyệt
vim.api.nvim_command("autocmd BufWritePost * :lua require('live_server').refresh_browser()")

-- Gán lệnh và phím tắt cho plugin
vim.api.nvim_set_keymap(
	"n",
	"<leader>ls",
	':lua require("live_server").start_live_server()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>lS",
	':lua require("live_server").stop_live_server()<CR>',
	{ noremap = true, silent = true }
)

return M
