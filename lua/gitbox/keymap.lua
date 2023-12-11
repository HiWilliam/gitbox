local view =require("gitbox.view")

local M = {}
local mapping = {
  ['<CR>'] = 'open_file()',
  q = 'close_window()',
  k = 'move_cursor()'
}

local command_keymap = {
  GitFileCommit = {
    ['C-j'] = ':lua require("gitbox.command").api.show_file_commit({direction = 1})<cr>',
    ['C-k'] = ':lua require("gitbox.command").api.show_file_commit({direction = -1})<cr>',
  }
}

local keymap_opts = {
  nowait = true,
  noremap = true,
  silent = true,
}

local function set_mappings()
  for k, v in pairs(mapping) do
    vim.api.nvim_buf_set_keymap(view.buf, 'n', k, ':lua view.'..v..'<cr>', {
     nowait = true,
     noremap = true,
     silent = true,
    })
  end

  if vim.g.current_command == "GitFileCommit" then
    for k, v in pairs(command_keymap.GitFileCommit) do
      vim.api.nvim_buf_set_keymap(view.buf, 'n', k, v, keymap_opts)
    end
  end

  local other_chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'i', 'n', 'o', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  }
  for _, v in pairs(other_chars) do
    vim.api.nvim_buf_set_keymap(view.buf, 'n', v, '', keymap_opts)
  end
end

function M.setup()
  set_mappings()
end

return M



