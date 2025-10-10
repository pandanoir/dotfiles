return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'folke/which-key.nvim' },
  cmd = { 'Telescope' },
  keys = {
    { '<leader>;', '<cmd>Telescope resume<cr>' },
  },
  init = function()
    require 'which-key'.add {
      { '<leader>f',  group = 'fuzzy finder', },
      {
        '<leader>fG',
        function() require('telescope.builtin').live_grep { default_text = vim.fn.expand('<cword>') } end,
        desc = 'Grep with current word'
      },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
      {
        '<leader>ff',
        function()
          local telescope = require 'telescope.builtin'
          local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
          if git_root and git_root ~= '' then
            telescope.find_files({ cwd = git_root })
          else
            telescope.find_files()
          end
        end,
        desc = 'Find files at git root'
      },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>',  desc = 'Grep' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>',   desc = 'Old files' },
      { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'Git status' },
    }

    -- add backdrop
    require 'easy-setup-autocmd'.setup_autocmd {
      ['FileType'] = {
        pattern = 'TelescopePrompt',
        callback = function(ctx)
          local backdropName = 'TelescopeBackdrop'
          -- `Telescope` does not set a zindex, so it uses the default value
          -- of `nvim_open_win`, which is 50: https://neovim.io/doc/user/api.html#nvim_open_win()
          local telescopeZindex = 50

          local backdropBufnr = vim.api.nvim_create_buf(false, true)
          local winnr = vim.api.nvim_open_win(backdropBufnr, false, {
            relative = 'editor',
            row = 0,
            col = 0,
            width = vim.o.columns,
            height = vim.o.lines,
            focusable = false,
            style = 'minimal',
            zindex = telescopeZindex - 1, -- ensure it's below the reference window
          })

          vim.api.nvim_set_hl(0, backdropName, { bg = '#000000', default = true })
          vim.wo[winnr].winhighlight = 'Normal:' .. backdropName
          vim.wo[winnr].winblend = 60
          vim.bo[backdropBufnr].buftype = 'nofile'

          -- close backdrop when the reference buffer is closed
          vim.api.nvim_create_autocmd({ 'WinClosed', 'BufLeave' }, {
            once = true,
            buffer = ctx.buf,
            callback = function()
              if vim.api.nvim_win_is_valid(winnr) then vim.api.nvim_win_close(winnr, true) end
              if vim.api.nvim_buf_is_valid(backdropBufnr) then
                vim.api.nvim_buf_delete(backdropBufnr, { force = true })
              end
            end,
          })
        end,
      }
    }
  end,
  config = function()
    local actions = require('telescope.actions')
    local function repeat_action(action, times)
      return function(...)
        for _ = 1, times do
          action(...)
        end
      end
    end

    require 'telescope'.setup {
      defaults = {
        mappings = {
          n = {
            q = 'close',
            ['<C-u>'] = repeat_action(actions.move_selection_previous, 8),
            ['<C-d>'] = repeat_action(actions.move_selection_next, 8),
          },
          i = {
            ['<C-u>'] = repeat_action(actions.move_selection_previous, 8),
            ['<C-d>'] = repeat_action(actions.move_selection_next, 8),
          }
        },
        path_display = { 'filename_first' },
      }
    }
  end
}
