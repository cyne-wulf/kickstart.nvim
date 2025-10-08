return {
  'echasnovski/mini.nvim',
  -- load at same time as kickstart’s mini (usually VeryLazy)
  event = 'VeryLazy',
  opts = function(_, _)
    -- you can tweak other mini modules here too
    require('mini.surround').setup {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        replace = 'gsr',
        find = '',
        highlight = '',
        update_n_lines = '',
      },
      custom_surroundings = {
        ['('] = { output = { left = '(', right = ')' } },
        [')'] = { output = { left = '(', right = ')' } },

        ['['] = { output = { left = '[', right = ']' } },
        [']'] = { output = { left = '[', right = ']' } },

        ['{'] = { output = { left = '{', right = '}' } },
        ['}'] = { output = { left = '{', right = '}' } },

        ['<'] = { output = { left = '<', right = '>' } },
        ['>'] = { output = { left = '<', right = '>' } },
      },
      -- ↓ this helps when your cursor isn't exactly inside the pair
      search_method = 'cover_or_next', -- "cover" default | "cover_or_next" | "cover_or_next_line"
    }
  end,
}
