local M = {}

local todo_file_path = "/Users/will/todo.txt"

function M.add_task()
  local new_task = vim.fn.input("Enter the new task: ")

  if new_task and #new_task > 0 then
    local file = io.open(todo_file_path, "a")
    if file then
      file:write("[ ] 1 " .. new_task .. "\n")
      file:close()
      print("Task added.")
    else
      print("Error: Unable to open file.")
    end
  end
end

function M.toggle_task()
  local current_line = vim.api.nvim_get_current_line()
  local new_line

  if string.sub(current_line, 1, 3) == "[ ]" then
    new_line = "[x]" .. string.sub(current_line, 4)
  elseif string.sub(current_line, 1, 3) == "[x]" then
    new_line = "[ ]" .. string.sub(current_line, 4)
  else
    return
  end

  vim.api.nvim_set_current_line(new_line)
end

function M.toggle_priority()
  local current_line = vim.api.nvim_get_current_line()
  local current_priority = tonumber(string.sub(current_line, 5, 5))
  local new_priority

  if current_priority == 1 then
    new_priority = 2
  elseif current_priority == 2 then
    new_priority = 3
  else
    new_priority = 1
  end

  local new_line = string.sub(current_line, 1, 4) .. new_priority .. string.sub(current_line, 6)
  vim.api.nvim_set_current_line(new_line)
end

-- Set keybindings
vim.api.nvim_set_keymap('n', '<localleader>at', ':lua require("nvim-plugins.todo").add_task()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>tt', ':lua require("nvim-plugins.todo").toggle_task()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>tp', ':lua require("nvim-plugins.todo").toggle_priority()<CR>', {noremap = true, silent = true})

return M

