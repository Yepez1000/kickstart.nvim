local function close_buffer()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    vim.ui.select({ 'Save and close', 'Discard changes', 'Cancel' }, { prompt = 'Buffer has unsaved changes:' }, function(choice)
      if choice == 'Save and close' then
        vim.cmd 'write'
        vim.cmd 'BufferLineCyclePrev'
        vim.cmd('bdelete ' .. buf)
      elseif choice == 'Discard changes' then
        vim.cmd 'BufferLineCyclePrev'
        vim.cmd('bdelete! ' .. buf)
      end
    end)
  else
    vim.cmd 'BufferLineCyclePrev'
    vim.cmd('bdelete ' .. buf)
  end
end

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  keys = {
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '<M-w>', close_buffer, desc = 'Close Buffer' },
  },
  opts = {
    options = {
      diagnostics = 'nvim_lsp',
      always_show_bufferline = true,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          highlight = 'Directory',
          separator = true,
        },
      },
    },
  },
}
