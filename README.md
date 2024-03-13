# live-server-nvim: plugin to run live-server in neovim


https://github.com/ngtuonghy/live-server-nvim/assets/116539745/e0cdf3ce-d637-4903-a8dc-8830b2f99920


## Requirements

[npm](https://www.npmjs.com/)

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua
 require("lazy").setup({
  {
    "ngtuonghy/live-server-nvim",
    event = "VeryLazy",
    build = ":LiveServerInstall",
    config = functions()
    require("live-server-nvim").setup{}
  },
})
```
# Configuration

- live-server-nvim will not run without setup

```lua
require('live-server-nvim').setup {
    custom = {
        "--port=8080",
        "--no-css-inject",
    },
 serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
 open = "folder", -- folder|cwd     --default
}

```

- Supported customized
  [see live-server](https://github.com/tapio/live-server#usage-from-command-line)

## Usage

```lua
LiveServerStart--Run server
LiveServerStop --Stop server
LiveServerToggle --Toggle server
```

- Custom mappings

```lua
vim.keymap.set("n", "<leader>lt", function() require("live-server-nvim").toggle() end)
```

## Thank you
