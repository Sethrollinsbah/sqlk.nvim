## **SQLk.nvim**

A Neovim plugin that uses [SQLk](https://github.com/sethrollinsbah/sqlk) for SQL query execution and visualization. 
This plugin allows you to run SQL queries directly from your Neovim buffer and view the results in a separate window.

-----

### **Features**

  * **Execute Queries:** Run SQL statements from your current buffer.
  * **Result Spreadsheet:** View query results in a dedicated, read-only Neovim buffer.
  * **Column Statistics:** Get statistics from your resultset + charts to detect anomalies.

-----

### **Requirements**

  * Neovim (v0.8 or higher)
  * **[SQLk](https://github.com/sethrollinsbah/sqlk)** (installed globally and available in your system's PATH)

-----

### **Installation**

#### **Lazy.nvim**

```lua
-- In your plugins/init.lua or another plugin file
return {
  "sethrollinsbah/sqlk.nvim",
  config = function()
    require("sqlk").setup()
  end,
}
```

#### **AstroNvim**

```lua
-- This would be a new file: lua/user/plugins/sqlk.lua
return {
  "sethrollinsbah/sqlk.nvim",
  cmd = "SQLk",
  config = function()
    require('sqlk').setup()
  end,
}
```

#### **vim-plug**

```vim
call plug#begin('~/.local/share/nvim/site/plugged')

" Add your plugins here
Plug 'sethrollinsbah/sqlk.nvim'

" Configuration after the plugin has been loaded
lua << EOF
  require('sqlk').setup()
EOF

call plug#end()
```

#### **Paq.nvim**

```lua
require("paq")({
  "savq/paq-nvim", -- Keep this line if you use Paq
  "sethrollinsbah/sqlk.nvim",
})
```

#### **Neovim Built-in Package Manager**

```bash
git clone https://github.com/sethrollinsbah/sqlk.nvim ~/.local/share/nvim/site/pack/plugins/start/sqlk.nvim
```

#### **Packer**

```lua
-- This assumes you have packer installed and the startup function is already in your config.
require('packer').startup(function(use)
  -- The plugin manager itself
  use 'wbthomason/packer.nvim'

  -- Your plugin
  use {
    'sethrollinsbah/sqlk.nvim',
    config = function()
      require('sqlk').setup()
    end,
  }

  -- Other plugins...
end)
```


-----

### **Configuration**

You can configure `sqlk.nvim` by calling the `setup()` function. The default configuration is as follows:

```lua
require('sqlk').setup({
  -- Path to your sqlk binary (optional, defaults to "sqlk")
  sqlk_path = "sqlk",
  -- Default database connection (optional)
  default_db = "postgres",
})
```

-----

### **Usage**

`sqlk.nvim` provides the following commands to interact with **sqlk**.

  * **:SQLk**

      * Launches SQLk with current buffer and root .env
