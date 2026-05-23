local keymap = vim.keymap

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear Hlsearch" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Code Block Down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Code Block Up" })
