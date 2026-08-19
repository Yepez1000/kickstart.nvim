return {
  'NickStafford2/copy-diagnostics.nvim',
  config = function()
    vim.g.copy_diagnostics_configuration = {
      keymap = {
        all = '<Leader>cy', -- copy all diagnostics in the buffer
        cursor = '<Leader>cY', -- reserved for future per-cursor copy
      },
    }
  end,
}
