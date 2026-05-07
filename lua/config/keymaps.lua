local map = vim.keymap.set

-- Better movement
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>")
map("n", "<C-Down>", "<cmd>resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Window management (<leader>w)
map("n", "<leader>wv", "<C-w>v",          { desc = "Split vertical" })
map("n", "<leader>ws", "<C-w>s",          { desc = "Split horizontal" })
map("n", "<leader>wd", "<cmd>silent! close<cr>", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o",          { desc = "Close other windows" })
map("n", "<leader>w=", "<C-w>=",          { desc = "Equalize windows" })
map("n", "<leader>wh", "<C-w>h",          { desc = "Go left" })
map("n", "<leader>wj", "<C-w>j",          { desc = "Go down" })
map("n", "<leader>wk", "<C-w>k",          { desc = "Go up" })
map("n", "<leader>wl", "<C-w>l",          { desc = "Go right" })
map("n", "<leader>wm", "<C-w>_<C-w>|",   { desc = "Maximize window" })

-- Buffers
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Better paste (keep register)
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Yank to system clipboard explicitly
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Delete to void
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void" })

-- Quickfix
map("n", "<leader>qn", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "<leader>qp", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Escape terminal / close floating terminal
map("t", "<Esc><Esc>", function()
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    pcall(vim.api.nvim_win_close, win, true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  end
end, { desc = "Exit terminal / close float" })

-- Close floating windows
map("n", "<Esc><Esc>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end
end, { desc = "Close floating windows" })

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
