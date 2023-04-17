-- plugin that sets text highlighting in txt files
--
-- Define a function to highlight text with a given color
local function highlight_text(color)
  local cmd = string.format("hi MyColor ctermfg=%s guifg=%s", color, color)
  vim.api.nvim_command(cmd)
end

-- Define a function to remove any previous highlighting
local function clear_highlighting()
  vim.api.nvim_command("hi clear MyColor")
end

-- Define a function to toggle highlighting on the current word
local function toggle_highlighting()
  local current_word = vim.fn.expand("<cword>")
  local current_color = vim.api.nvim_get_hl_by_name("MyColor", true).foreground
  local new_color = current_color == nil or current_color == "NONE" and "red" or "NONE"
  clear_highlighting()
  if new_color ~= "NONE" then
    highlight_text(new_color)
  end
  vim.fn.matchadd("MyColor", "\\b" .. current_word .. "\\b", -1)
end

-- Set up an autocmd to call toggle_highlighting when the cursor moves
vim.api.nvim_command("augroup highlight_txt")
vim.api.nvim_command("autocmd!")
vim.api.nvim_command("autocmd CursorMoved * call v:lua.toggle_highlighting()")
vim.api.nvim_command("augroup END")

