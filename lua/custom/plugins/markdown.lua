return {
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',

    -- Use the plugin’s own install helper to avoid yarn.lock churn
    build = ':call mkdp#util#install()',

    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      -- Optional extras:
      -- vim.g.mkdp_browser = "safari"       -- force a browser
      -- vim.g.mkdp_auto_close = 0           -- keep tab open after Neovim quits
    end,
  },
}
