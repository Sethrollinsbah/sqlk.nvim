vim.api.nvim_create_user_command("SQLk", function()
  require('sqlk').open_tui()
end, {})
