vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab


-- split window navigation
keymap.set("n", "<C-Left>", "<C-w>h", { noremap = true, silent = true, desc = "Move cursor left" })
keymap.set("n", "<C-Right>", "<C-w>l", { noremap = true, silent = true, desc = "Move cursor right" })
keymap.set("n", "<C-Up>", "<C-w>k", { noremap = true, silent = true, desc = "Move cursor up" })
keymap.set("n", "<C-Down>", "<C-w>j", { noremap = true, silent = true, desc = "Move cursor down" })

-- toggle search highlighting
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Toggle search highlighting" })


-- resize windows
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" }) -- increase window height
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" }) -- decrease window height
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" }) -- decrease window width
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" }) -- increase window width

-- move selected lines up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" }) -- move selected lines down
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" }) -- move selected lines up

