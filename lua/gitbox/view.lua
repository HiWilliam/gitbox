local api = vim.api
local buf, win, border_buf, border_win
local M = {
  buf = nil,
  win = nil,
  border_buf = nil,
  border_win = nil,
}

local function center(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end



function M.open_window()
  buf = api.nvim_create_buf(false, true);
  border_buf = vim.api.nvim_create_buf(false, true)
  M.buf, M.border_buf = buf, border_buf

  vim.bo.bufhidden = "wipe";

  -- get current window width and height
  local width = vim.o.columns;
  local height = vim.o.lines;

  -- calculate the popup window width and height
  local win_width = math.ceil(width * 0.8 - 4)
  local win_height = math.ceil(height * 0.8)

  -- calculate the popup window start positoin
  local row = math.ceil((height - win_height) / 2 -1)
  local col = math.ceil((width - win_width ) / 2)

  -- add border options
  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width + 2,
    height = win_height + 2,
    row = row - 1,
    col = col - 1
  }

  -- add some options
  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    col = col,
    row = row,
  }

  local border_lines = { '╔' .. string.rep('═', win_width) .. '╗' }
  local middle_line = '║' .. string.rep(' ', win_width) .. '║'
  for i=1, win_height do
    table.insert(border_lines, middle_line)
  end
  table.insert(border_lines, '╚' .. string.rep('═', win_width) .. '╝')
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  win = api.nvim_open_win(buf, true, opts)
  border_win = vim.api.nvim_open_win(border_buf, true, border_opts)
  M.win, M.border_win = win, border_win
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)
  api.nvim_create_autocmd('BufWipeout', {
    command = 'silent bwipeout!' ..buf,
  })

  api.nvim_set_option_value('cursorline', true, {win = win} )
  api.nvim_buf_set_lines(buf, 0, -1, false, { center('What have i done?'), '', ''})
  api.nvim_buf_add_highlight(buf, -1, 'WindowHeader', 0, 0, -1)
end

function M.draw(title, result)
  vim.bo.modifiable = true

  -- set header - title
  api.nvim_buf_set_lines(buf, 1, 2, false, {center(title)})
  -- set content
  api.nvim_buf_set_lines(buf, 2, -1, false, result)
  api.nvim_buf_add_highlight(buf, -1, 'WindowSubHeader', 1, 0, -1)
  -- set start cursor positon
  api.nvim_win_set_cursor(win, {3, 0})

  vim.bo.modifiable = false

end

function M.close_window()
  api.nvim_win_close(win, true)
  api.nvim_win_close(border_win, true)
end

function M.open_file()
  local str = api.nvim_get_current_line()
  M.close_window()
  api.nvim_command("edit "..str)
end

function M.move_cursor()
  local new_pos = math.max(3, api.nvim_win_get_cursor(win)[1] - 1)
  api.nvim_win_set_cursor(win, {new_pos, 0})
end


return M
