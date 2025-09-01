local M = {}

M.config = {
  binary_path = "sqlk", -- Default to system PATH
  env_file = ".env",
  file_pattern = "*.sql",
  width_ratio = 0.8,
  height_ratio = 0.8,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Helper function to find the sqlk binary
local function find_sqlk_binary()
  -- First, try the configured path
  if M.config.binary_path ~= "sqlk" and vim.fn.executable(M.config.binary_path) == 1 then
    return M.config.binary_path
  end
  -- Try to find sqlk in PATH
  if vim.fn.executable("sqlk") == 1 then
    return "sqlk"
  end
  -- Try common cargo install locations
  local home = vim.fn.expand("~")
  local cargo_bin_path = home .. "/.cargo/bin/sqlk"
  if vim.fn.executable(cargo_bin_path) == 1 then
    return cargo_bin_path
  end
  -- On some systems, cargo installs to different locations
  local alt_paths = {
    "/usr/local/bin/sqlk",
    home .. "/.local/bin/sqlk",
  }
  for _, path in ipairs(alt_paths) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

function M.open_tui()
  -- Check if current buffer is a .sql file
  local current_file = vim.fn.expand("%")
  local file_extension = vim.fn.fnamemodify(current_file, ":e")
  if file_extension ~= "sql" then
    vim.notify("SQLk can only be launched from .sql files", vim.log.levels.WARN)
    return
  end
  -- Find the sqlk binary
  local binary_path = find_sqlk_binary()
  if not binary_path then
    vim.notify(
      "SQLk binary not found. Please install it with: cargo install sqlk\n" ..
      "Or specify the path in your config: require('sqlk').setup({ binary_path = '/path/to/sqlk' })",
      vim.log.levels.ERROR
    )
    return
  end
  -- Get absolute path to current SQL file
  local current_file_abs = vim.fn.expand("%:p")
  -- Find .env file by searching up the directory tree
  local env_path = vim.fn.findfile(M.config.env_file, ".;")
  if env_path == "" then
    vim.notify("Environment file not found: " .. M.config.env_file, vim.log.levels.ERROR)
    return
  end
  -- Convert to absolute path
  env_path = vim.fn.fnamemodify(env_path, ":p")
  -- Check if .env file actually exists
  if vim.fn.filereadable(env_path) == 0 then
    vim.notify("Environment file not readable: " .. env_path, vim.log.levels.ERROR)
    return
  end
  -- Build the command - using current file instead of pattern
  local cmd = string.format('%s --env "%s" --file "%s"',
    binary_path,
    env_path,
    current_file_abs
  )
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * M.config.width_ratio)
  local height = math.floor(vim.o.lines * M.config.height_ratio)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.fn.termopen(cmd)
  -- Set shorter timeouts for this buffer to reduce lag
  vim.api.nvim_buf_set_option(buf, "timeoutlen", 1)
  vim.api.nvim_buf_set_option(buf, "ttimeoutlen", 1)
  -- Force enter terminal mode immediately
  vim.cmd("startinsert")
  -- Set buffer options for better terminal behavior
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  -- Optional: Set up keymaps for this specific buffer
  local keymap_opts = { buffer = buf, nowait = true, silent = true }
  -- Map Escape to close the terminal (if desired)
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>:q<CR>", keymap_opts)
  -- Ensure terminal gets focus
  vim.api.nvim_set_current_win(win)
end

-- Convenience function to check if sqlk is available
function M.check_installation()
  local binary_path = find_sqlk_binary()
  if binary_path then
    vim.notify("SQLk found at: " .. binary_path, vim.log.levels.INFO)
    return true
  else
    vim.notify("SQLk not found. Install with: cargo install sqlk", vim.log.levels.WARN)
    return false
  end
end

return M
