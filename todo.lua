local M = {}

local todo_file_path = "/Users/will/todo.txt"

function M.add_task()
  local new_task = vim.fn.input("Enter the new task: ")

  if new_task and #new_task > 0 then
    local file = io.open(todo_file_path, "a")
    if file then
      file:write("[ ] " .. new_task .. " (1)\n")
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
  local priority_start, priority_end = string.find(current_line, "%(%d%)")
  local current_priority = tonumber(string.sub(current_line, priority_start + 1, priority_end - 1))
  local new_priority

  if current_priority == 1 then
    new_priority = 2
  elseif current_priority == 2 then
    new_priority = 3
  else
    new_priority = 1
  end

  local new_line = string.sub(current_line, 1, priority_start) .. new_priority .. string.sub(current_line, priority_end)
  vim.api.nvim_set_current_line(new_line)
end

function M.swap_task(direction)
  local current_line_number = vim.api.nvim_win_get_cursor(0)[1]
  local target_line_number = current_line_number + direction

  if target_line_number < 1 then
    print("Cannot move task further up.")
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, current_line_number - 1, current_line_number + 1, false)
  local target_line = lines[2]

  if not target_line then
    print("Cannot move task further down.")
    return
  end

  vim.api.nvim_buf_set_lines(0, current_line_number - 1, current_line_number, false, {target_line})
  vim.api.nvim_buf_set_lines(0, target_line_number - 1, target_line_number, false, {lines[1]})
  vim.api.nvim_win_set_cursor(0, {target_line_number, 0})
end

function M.toggle_subtask()
  local current_line = vim.api.nvim_get_current_line()
  local new_line = "\t" .. current_line
  vim.api.nvim_set_current_line(new_line)
end


function M.add_blank_task()
  local new_task = "[ ]  (1)"
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  local current_line_number = cursor_position[1]

  vim.api.nvim_buf_set_lines(0, current_line_number, current_line_number, false, {new_task})
  vim.api.nvim_win_set_cursor(0, {current_line_number + 1, 0})
  print("Blank task added.")
end




-- Set keybindings
vim.api.nvim_set_keymap('n', '<localleader>at', ':lua require("todo").add_task()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>tt', ':lua require("todo").toggle_task()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>tp', ':lua require("todo").toggle_priority()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>su', ':lua require("todo").swap_task(-1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>sd', ':lua require("todo").swap_task(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<localleader>ts', ':lua require("todo").toggle_subtask()<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<localleader>ab', ':lua require("todo").add_blank_task()<CR>', {noremap = true, silent = true})

-- Vim normal mode command to open the todo list page
vim.cmd("command! Todo :e " .. todo_file_path)



return M

