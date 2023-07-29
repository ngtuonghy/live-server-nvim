# live-server-nvim: plugin to run live-server in neovim

## Requirements

<p>npm <a href="https://www.npmjs.com/" target="_blank">see</a></p>

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua
 require("lazy").setup({
  {
  "ngtuonghy/live-server-nvim",
  config = functions()
  require("live-server-nvim").setup{}
  },
})
```

## Configuration

- Recommended setup

```lua
require('live-server-nvim').setup{
 custom = {
        "--port=8080",
        "--quiet",
        "--no-css-inject",
    },
 serverpath = vim.fn.stdpath("data") .. "/live-server/",
 open = "folder", --folder|cwd
}

```

- Supported customized
  [see live-server](https://github.com/tapio/live-server#usage-from-command-line)

## Usage

```lua
LiveServerStart--Run sever
LiveServerStop --Stop sever
LiveServerToggle --Toggle sever
```

- Custom mappings

```lua
vim.keymap.set("n", "<leader>lt", function() require("live-server-nvim").toggle() end)
```

## Thank you
