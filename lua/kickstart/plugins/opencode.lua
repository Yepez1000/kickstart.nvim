-- https://github.com/nickjvandyke/opencode.nvim

return {
  'nickjvandyke/opencode.nvim',
  version = '*', -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      'folke/snacks.nvim',
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require('opencode').snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                -- ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
      server = {
        start = function()
          require('opencode.terminal').open('opencode --port', {
            split = 'right',
            width = math.floor(vim.o.columns * 0.25), -- Make window 25% of screen width (smaller)
          })
        end,
        stop = function()
          require('opencode.terminal').close()
        end,
        toggle = function()
          require('opencode.terminal').toggle('opencode --port', {
            split = 'right',
            width = math.floor(vim.o.columns * 0.25), -- Make window 25% of screen width (smaller)
          })
        end,
      },
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Set up tmux navigation keybindings and escape fix for opencode terminal
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function(event)
        -- Check if this is the opencode terminal
        local job_id = vim.b[event.buf].terminal_job_id
        if job_id then
          local opts = { buffer = event.buf, silent = true }

          -- Fix: Exit terminal mode cleanly with single Escape press
          -- Terminal mode -> Normal mode directly
          vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', vim.tbl_extend('force', opts, { desc = 'Exit terminal mode' }))

          -- Tmux navigation - use the exact same format as vim-tmux-navigator
          -- These will trigger the lazy loading of the plugin
          vim.keymap.set('t', '<C-h>', '<C-\\><C-n><Cmd>TmuxNavigateLeft<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate left (tmux)' }))
          vim.keymap.set('t', '<C-j>', '<C-\\><C-n><Cmd>TmuxNavigateDown<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate down (tmux)' }))
          vim.keymap.set('t', '<C-k>', '<C-\\><C-n><Cmd>TmuxNavigateUp<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate up (tmux)' }))
          vim.keymap.set('t', '<C-l>', '<C-\\><C-n><Cmd>TmuxNavigateRight<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate right (tmux)' }))

          -- Also add for normal mode when browsing the terminal output
          vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate left (tmux)' }))
          vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate down (tmux)' }))
          vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate up (tmux)' }))
          vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', vim.tbl_extend('force', opts, { desc = 'Navigate right (tmux)' }))
        end
      end,
    })

    -- Toggle OpenCode panel
    vim.keymap.set({ 'n', 't' }, '<leader>oc', function()
      require('opencode').toggle()
    end, { desc = 'Toggle OpenCode AI' })

    -- Recommended/example keymaps
    vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode…' })
    vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action…' })
    vim.keymap.set({ 'n', 't' }, '<C-.>', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })

    vim.keymap.set({ 'n', 'x' }, 'go', function()
      return require('opencode').operator '@this '
    end, { desc = 'Add range to opencode', expr = true })
    vim.keymap.set('n', 'goo', function()
      return require('opencode').operator '@this ' .. '_'
    end, { desc = 'Add line to opencode', expr = true })

    vim.keymap.set('n', '<S-C-u>', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'Scroll opencode up' })
    vim.keymap.set('n', '<S-C-d>', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'Scroll opencode down' })

    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
    vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment under cursor', noremap = true })
    vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement under cursor', noremap = true })

    -- Focus OpenCode terminal with 'gi' in normal mode
    vim.keymap.set('n', 'gi', function()
      -- Find the opencode terminal window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.fn.bufname(buf)
        -- Check if this is a terminal buffer (usually term:// or empty name for term buffers)
        if vim.bo[buf].buftype == 'terminal' then
          vim.api.nvim_set_current_win(win)
          vim.cmd 'startinsert'
          return
        end
      end
      -- If terminal not found, toggle it to open
      require('opencode').toggle()
      vim.schedule(function()
        vim.cmd 'startinsert'
      end)
    end, { desc = 'Focus OpenCode terminal and enter insert mode' })
  end,
}
