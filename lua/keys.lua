local function map(mode, lhs, rhs, opts)
  -- set default value if not specify
  if opts.noremap == nil then opts.noremap = true end

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- verticially split the window and move to the new one
map("n", "<leader>w", "<C-W>v<C-W>l", { noremap = true })

-- Move between windows
map("n", "<leader>wj", "<C-W>j", { noremap = true })
map("n", "<leader>wk", "<C-W>k", { noremap = true })
map("n", "<leader>wh", "<C-W>h", { noremap = true })
map("n", "<leader>wl", "<C-W>l", { noremap = true })
map("n", "<leader>w-", "<C-W>-", { noremap = true })
map("n", "<leader>w+", "<C-W>+", { noremap = true })
map("n", "<leader>w=", "<C-W>=", { noremap = true })
map("n", "<leader>w,", "<C-W>,", { noremap = true })
map("n", "<leader>w.", "<C-W>.", { noremap = true })
map("t", "<A-j>", "<C-W>j", { noremap = true })
map("t", "<A-k>", "<C-W>k", { noremap = true })
map("t", "<A-h>", "<C-W>h", { noremap = true })
map("t", "<A-l>", "<C-W>l", { noremap = true })

map("n", "<leader>rd", ":redraw<CR>", { noremap = true })

map("n", "<leader>tw", ":tabnew<CR>", { noremap = true })
map("n", "<leader>te", ":tabedit<CR>", { noremap = true })
map("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
map("n", "<leader>tm", ":tabmove<CR>", { noremap = true })
map("n", "<leader>tn", ":tabnext<CR>", { noremap = true })
map("n", "<leader>tp", ":tabprevious<CR>", { noremap = true })
map("n", "<leader>tf", ":tabfirst<CR>", { noremap = true })
map("n", "<leader>tl", ":tablast<CR>", { noremap = true })

-- change the working directory to that of the current file
map("n", "cd.", "lcd %:p:h", { noremap = true })

-- clear highlight
map("n", "<leader><space>", ":noh<CR>", { noremap = true })

-- strip trailing spaces
map("n", "<leader>W", ":%s/\\s\\+$//<CR>:let @/=\"\"<CR>", { noremap = true })

