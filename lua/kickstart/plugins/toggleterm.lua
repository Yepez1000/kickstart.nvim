-- https://github.com/akinsho/toggleterm.nvim

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- 1. Default layout: 'horizontal', 'vertical', or 'float'
      direction = 'float',
      -- 2. Open mapping: This toggles the terminal
      open_mapping = [[<c-\>]],
      -- 3. Styling the float
      float_opts = {
        border = 'curved',
        winblend = 3,
      },
      -- 4. Automatically insert mode when opening
      start_in_insert = true,
    }
  end,
}
