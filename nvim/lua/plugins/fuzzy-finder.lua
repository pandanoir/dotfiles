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
      { '<leader>fb', '<cmd>Telescope buffers<cr>',    desc = 'Buffers' },
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find File' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>',  desc = 'Grep' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>',   desc = 'Old files' },
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
  opts = {
    defaults = {
      mappings = {
        n = { q = 'close' },
      },
    },
  },
}
