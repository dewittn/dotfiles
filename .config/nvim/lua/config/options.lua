-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Suppress noisy LSP transport warnings (Neovim 0.11.x logs LSP stderr as warnings)
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match("_transport%.lua") then
    return
  end
  return original_notify(msg, level, opts)
end

-- vim.opt.relativenumber = false
vim.filetype.add({ extensions = { tpl = "yaml" } })
-- vim.cmd("set expnadtab")
-- vim.cmd("set tabspot=2")
-- vim.cmd("set softtabstop=2")
-- vim.cmd("set shiftwidth=2")
