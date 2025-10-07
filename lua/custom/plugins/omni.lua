return {
  {
    'sylvanfranklin/omni-preview.nvim',
    ft = { 'typst', 'markdown', 'csv' },

    dependencies = {
      -- Typst (needs Tinymist from Mason)
      {
        'chomosuke/typst-preview.nvim',
        version = '1.*',
        build = function()
          require('typst-preview').update()
        end,
        opts = {
          dependencies_bin = {
            tinymist = vim.fn.stdpath 'data' .. '/mason/bin/tinymist',
          },
        },
      },

      { 'hat0uma/csvview.nvim', lazy = true }, -- CSV (optional)
    },

    -- We leave Omni’s own defaults untouched
    opts = true,

    -- Unified key-maps --------------------------------------------------
    keys = {
      {
        '<leader>po',
        function()
          if vim.bo.filetype == 'markdown' then
            vim.cmd 'MarkdownPreviewToggle' -- start/stop in one cmd
          else
            vim.cmd 'OmniPreview start' -- Typst, CSV, …
          end
        end,
        desc = 'Preview (Typst/Markdown/CSV/…)',
      },
      {
        '<leader>pc',
        function()
          if vim.bo.filetype == 'markdown' then
            vim.cmd 'MarkdownPreviewStop'
          else
            vim.cmd 'OmniPreview stop'
          end
        end,
        desc = 'Close preview',
      },
    },
  },
}
