local command = require("gitbox.command")
local keymap = require("gitbox.keymap")
local M = {}

M.setup = function ()
   -- Prevent the script from being loaded more than once
  if vim.g.gitbox_loaded then
    return
  end

  -- Save and set 'cpo' to an empty string
  local save_cpo = vim.o.cpo
  vim.o.cpo = vim.o.cpo .. 'vim'

  -- Define highlighting rules
  vim.cmd([[
    hi def link WindowHeader Number
    hi def link WindowSubHeader Identifier
  ]])

  if vim.g.gitbox_loaded ~= true then
    command.setup()
    keymap.setup()
  end

  -- Restore 'cpo' to its original value
  vim.o.cpo = save_cpo

  -- Mark the script as loaded
  vim.g.gitbox_loaded = true

end

return M
