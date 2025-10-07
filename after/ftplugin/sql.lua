vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.commentstring = '-- %s'

vim.bo.omnifunc = 'vim_dadbod_completion#omni'

if not vim.b.sql_type or vim.b.sql_type == '' then
  vim.b.sql_type = 'pgsql'
end
