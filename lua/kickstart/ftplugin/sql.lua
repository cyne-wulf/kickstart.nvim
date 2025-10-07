-- lua/ftplugin/sql.lua
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.commentstring = '-- %s'

-- 🔑 enable dadbod-completion backend
vim.bo.omnifunc = 'vim_dadbod_completion#omni'
