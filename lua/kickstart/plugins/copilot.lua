-- https://github.com/zbirenbaum/copilot.lua
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = true, -- Automatically trigger suggestions
          keymap = {
            accept = '<Tab>', -- Map Tab to accept suggestion (adjust for your config)
            -- ... other keymaps
          },
        },
        panel = { enabled = false }, -- Disable the separate panel for simpler inline workflow
        -- ... other settings
      }
    end,
  },
}
