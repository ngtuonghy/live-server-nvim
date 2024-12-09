# live-server-nvim: plugin to run live-server in neovim

https://github.com/ngtuonghy/live-server-nvim/assets/116539745/03613e49-fcc7-492a-8c70-040f2f8cb2b1

##  Features

 - Always find and run the index.html file regardless of where you are in the project root
 - Run the currently opened file

## Requiements

 - [npm](https://docs.npmjs.com/cli)

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua
 require("lazy").setup({
  {
    {
	  "ngtuonghy/live-server-nvim",
	  event = "VeryLazy",
	  build = ":LiveServerInstall",
	  config = function()
	  require("live-server-nvim").setup({})
	  end,
    }, 
})
```

# Configuration

- live-server-nvim will not run without setup

```lua
require('live-server-nvim').setup ({
    custom = {
        "--port=8080",
        "--no-css-inject",
    },
 serverPath = vim.fn.stdpath("data") .. "/live-server/", --default
 open = "folder", -- folder|cwd     --default
})

```
- Supported customized [see live-server](https://github.com/tapio/live-server#usage-from-command-line)

## Usage

```lua
LiveServerStart--Run server
LiveServerStart -f    -- Serve the currently open file (Note: for this to work, `open` mode in setup must be set to "folder")
LiveServerStop --Stop server
LiveServerToggle --Toggle server
```
## Custom mappings

```lua
vim.keymap.set("n", "<leader>lt", function() require("live-server-nvim").toggle() end)
```

## Contributors
Many thanks to those who have contributed to the project!

[@beka-birhanu](https://github.com/beka-birhanu)
