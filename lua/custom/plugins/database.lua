-- lua/custom/plugins/database.lua
return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  config = function()
    -- Define your database connection for your class
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.dbs = {
      ['cse180-db'] = 'postgresql://cse180:database4me@localhost:5432/cse180',
    }
  end,
  keys = {
    { '<leader>db', '<cmd>DBUIToggle<cr>', desc = 'Database UI' },
  },
}
