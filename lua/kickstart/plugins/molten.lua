-- https://github.com/benlubas/molten-nvim?tab=readme-ov-file
return {
  'benlubas/molten-nvim',
  version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
  dependencies = { '3rd/image.nvim' },
  build = ':UpdateRemotePlugins',
  init = function()
    vim.g.molten_image_provider = 'image.nvim'
    vim.g.molten_output_win_max_height = 20

    local function get_venv_python()
      local cwd = vim.fn.getcwd()
      local venv_python = cwd .. '/venv/bin/python'
      if vim.fn.filereadable(venv_python) == 1 then
        return venv_python
      end
      venv_python = cwd .. '/.venv/bin/python'
      if vim.fn.filereadable(venv_python) == 1 then
        return venv_python
      end
      return nil
    end

    local function get_project_name()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    end

    vim.keymap.set('n', '<localleader>ik', function()
      local venv_python = get_venv_python()
      if not venv_python then
        vim.notify('No venv found in ./venv or ./.venv', vim.log.levels.ERROR)
        return
      end

      local project_name = get_project_name()
      local venv_pip = vim.fn.fnamemodify(venv_python, ':h') .. '/pip'

      vim.notify('Installing ipykernel...', vim.log.levels.INFO)
      vim.fn.jobstart(venv_pip .. ' install ipykernel', {
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            vim.notify('Failed to install ipykernel', vim.log.levels.ERROR)
            return
          end
          vim.notify('Registering kernel: ' .. project_name, vim.log.levels.INFO)
          vim.fn.jobstart(venv_python .. ' -m ipykernel install --user --name=' .. project_name, {
            on_exit = function(_, code)
              if code == 0 then
                vim.notify('Kernel "' .. project_name .. '" ready!', vim.log.levels.INFO)
              else
                vim.notify('Failed to register kernel', vim.log.levels.ERROR)
              end
            end,
          })
        end,
      })
    end, { desc = 'Setup Jupyter kernel for venv', silent = true })

    vim.keymap.set('n', '<localleader>ip', function()
      local venv_python = get_venv_python()
      if venv_python then
        local project_name = get_project_name()
        vim.cmd('MoltenInit ' .. project_name)
      else
        vim.cmd 'MoltenInit python3'
      end
    end, { desc = 'Initialize Molten with venv kernel', silent = true })
  end,
}
