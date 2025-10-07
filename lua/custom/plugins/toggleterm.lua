-- lua/custom/plugins/toggleterm.lua
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    -- configuration options go here
    open_mapping = [[<c-\>]], -- A common mapping to open the terminal
    direction = 'float',
  },
  keys = {
    -- A more memorable keymap for a floating terminal
    { '<leader>tt', '<cmd>ToggleTerm direction=float<cr>', desc = 'Floating Terminal' },
  },
}
