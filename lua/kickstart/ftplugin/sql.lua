-- lua/ftplugin/sql.lua
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.commentstring = '-- %s'

-- 🔑 enable dadbod-completion backend
vim.bo.omnifunc = 'vim_dadbod_completion#omni'

-- Default to postgres dialect
if not vim.b.sql_type or vim.b.sql_type == '' then
  vim.b.sql_type = 'pgsql' -- Used by your custom Blink dadbod adapter
  vim.b.sql_type_override = 'pgsql' -- Used by Vim's built-in syntax highlighting
end
