local view = require("gitbox.view")
local M = {
  api = {}
}
local CommandNames = {
  GitFileCommit = "GitFileCommit",
  GitShowStatus = "GitShowStatus",
}

local function show_commit_diff(opts)
  local position = 0
  local direction = 0
  direction = opts.direction
  position = position + direction
  if position < 0 then position = 0 end
  local result =  vim.fn.systemlist("git diff-tree --no-commit-id --name-only -r Head~"..position)

  view.draw('Head~'..position, result)
  vim.g.current_command = CommandNames.GitFileCommit
end

local function show_current_status(_)
  local result = vim.fn.systemlist("git status -s")
  view.draw("Status", result)
  vim.g.current_command = CommandNames.GitShowStatus
end

local function execCmd(cmd, opts)
  view.open_window()
  cmd(opts)
end

local commands = {
  {
    name = CommandNames.GitFileCommit,
    opt = {
      desc = "show the specify commit diffrent with current head",
    },
    func = function ()
      execCmd(show_commit_diff, {direction = 0})
    end
  },
  {
    name = CommandNames.GitShowStatus,
    opt = {
      desc = "show the current file status",
    },
    func = function ()
      execCmd(show_current_status, {})
    end
  }
}

M.api.show_commit_diff    = show_commit_diff
M.api.show_current_status = show_current_status

function M.setup()
  for _, cmd in pairs(commands) do
    vim.api.nvim_create_user_command(cmd.name, cmd.func, cmd.opt)
  end
end

return M
