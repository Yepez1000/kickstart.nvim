-- https://github.com/akinsho/toggleterm.nvim

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- 1. Default layout: 'horizontal', 'vertical', or 'float'
      direction = 'float',
      -- 2. Open mapping: This toggles the terminal with <leader>t
      -- You can use counts to toggle specific terminals: 2<leader>t for terminal 2, etc.
      open_mapping = [[<leader>']],
      -- 3. Styling the float
      float_opts = {
        border = 'curved',
        winblend = 3,
      },
      -- 4. Automatically insert mode when opening
      start_in_insert = false,
      -- 5. Close terminal when the process exits
      close_on_exit = true,
    }

    -- 5. Configure keymaps for terminal mode
    local Terminal = require('toggleterm.terminal').Terminal

    -- Auto-command to set up terminal keymaps
    vim.api.nvim_create_autocmd('TermOpen', {
      group = vim.api.nvim_create_augroup('ToggleTermKeymaps', { clear = true }),
      callback = function()
        -- Map Escape to close the terminal in terminal mode
        vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = 0, noremap = true })
      end,
    })

    -- Only allow toggling terminal in normal mode
    -- Remove the default mapping and create a normal mode only mapping
    vim.keymap.set('n', "<leader>'", '<Cmd>ToggleTerm<CR>', { noremap = true, silent = true })

    local current_file_terminal = Terminal:new {
      direction = 'float',
      hidden = true,
    }

    vim.api.nvim_create_user_command('ToggleTermCurrentFile', function()
      local directory = vim.fn.expand '%:p:h'
      if directory == '' then
        directory = vim.fn.getcwd()
      end

      current_file_terminal.dir = directory
      current_file_terminal:toggle()
    end, {})

    vim.keymap.set('n', '<leader>t-', '<Cmd>ToggleTermCurrentFile<CR>', {
      desc = 'Toggle terminal at current file',
      noremap = true,
      silent = true,
    })
  end,
}
