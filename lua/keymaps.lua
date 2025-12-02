-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- CUSTOM AREA

-- Map 'jk' and 'kj' to exit insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true, desc = 'Exit insert mode with jk' })
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true, silent = true, desc = 'Exit insert mode with kj' })

-- Maps j and k to move by visual lines, meaning if word wrap has made many "virtual lines" out of a single line, you can move up and down within the single line.
-- (May break some advanced motions, but very helpful for editing text like I am in typst)
vim.keymap.set('n', 'j', 'gj', { desc = 'Move down by visual line' })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move up by visual line' })

-- Leader Key Macros:
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>n', ':bnext<CR>', { desc = '[B]uffer [N]ext (faster)' })

vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>d', ':bdelete<CR>', { desc = '[B]uffer [D]elete (faster)' })

-- -------------
-- Mini Surround Keybinds

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local ok, surround = pcall(require, 'mini.surround')
    if not ok then
      return
    end
    local map = vim.keymap.set
    map('n', 'gsa', surround.add, { desc = 'Add surround' })
    map('n', 'gsd', surround.delete, { desc = 'Delete surround' })
    map('n', 'gsr', surround.replace, { desc = 'Replace surround' })
    map('n', 'gsf', surround.find, { desc = 'Find surround forward' })
    map('n', 'gsh', surround.highlight, { desc = 'Highlight surround' })
    map('n', 'gsn', surround.update_n_lines, { desc = 'Update search n_lines' })
  end,
})

-- Your other commented out "fat fingering" binds (if you want to re-enable any):
-- vim.api.nvim_set_keymap('i', 'fd', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', 'hj', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', 'kl', '<Esc>', { noremap = true, silent = true })

-- --- ADDED: Helix-style clipboard mappings ---
-- Use 'g' prefix for system clipboard operations, leaving default y/p/d for internal registers.
-- In Neovim, `"+` is the system clipboard register.
local map = vim.keymap.set
-- Normal mode
map('n', 'gy', '"+y', { desc = '[G]lobal Yank to system clipboard' })
map('n', 'gp', '"+p', { desc = '[G]lobal Paste after from system clipboard' })
map('n', 'gP', '"+P', { desc = '[G]lobal Paste before from system clipboard' })
-- Visual mode
map('v', 'gy', '"+y', { desc = '[G]lobal Yank selection to system clipboard' })
map('v', 'gp', '"+p', { desc = '[G]lobal Paste over selection from system clipboard' })
-- ---------------------------------------------

-- ============================================================
-- macOS-style text navigation for ONLY Kitty
-- (see advanced-Neovim for comments on signals sent by other terminal emulators)
-- ============================================================
-- Cmd  ←/→ : start/end of line
-- Opt  ←/→ : word left/right

-- ---------- INSERT MODE ----------
-- Use <C-o>{motion} so we reuse normal-mode motions safely.
map('i', '<M-Left>', '<C-o>b') -- word left
map('i', '<M-Right>', '<C-o>w') -- word right
map('i', '<D-Left>', '<C-o>0') -- start of line
map('i', '<D-Right>', '<C-o>$') -- end of line

-- ---------- COMMAND-LINE MODE (:, /, ?) ----------
-- Rely on built-in command-line editing keys.
map('c', '<M-Left>', '<C-Left>') -- word left
map('c', '<M-Right>', '<C-Right>') -- word right
map('c', '<D-Left>', '<Home>') -- start of line
map('c', '<D-Right>', '<End>') -- end of line

-- ---------- NORMAL MODE ----------
map('n', '<M-Left>', 'b') -- word left
map('n', '<M-Right>', 'w') -- word right
map('n', '<D-Left>', '0') -- start of line
map('n', '<D-Right>', '$') -- end of line

-- ============================================================

-- LEGACY CLIPBOARD BEHAVIOR START --------------------------------------------------------------

-- Allow clipboard copy paste in neovim (Neovide specific for <D-*> keys)
-- vim.g.neovide_input_use_logo = 1

-- Paste
-- vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true, desc = 'Paste from clipboard' })
-- vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true, desc = 'Paste from clipboard in Command-line' })
-- vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true, desc = 'Paste from clipboard in Terminal mode' })
-- vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true, desc = 'Paste from clipboard in Visual mode' })

-- Copy
-- vim.api.nvim_set_keymap('v', '<D-c>', '"+y', { noremap = true, silent = true, desc = 'Copy to clipboard' })
-- vim.api.nvim_set_keymap('n', '<D-c>', '"+yy', { noremap = true, silent = true, desc = 'Copy current line to clipboard' })

-- Cut
-- vim.api.nvim_set_keymap('v', '<D-x>', '"+d', { noremap = true, silent = true, desc = 'Cut to clipboard' })
-- vim.api.nvim_set_keymap('n', '<D-x>', '"+dd', { noremap = true, silent = true, desc = 'Cut current line to clipboard' })
--

-- END LEGACY CLIPBOARD BEHAVIOR BLOCK ---------------------------------------------------------------

-- Oil Keymap
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- ALWAYS LEAVE BOTTOM ALONE
-- vim: ts=2 sts=2 sw=2 et
