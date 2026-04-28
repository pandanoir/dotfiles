return {
  { -- ファイルエクスプローラー
    'stevearc/oil.nvim',
    opts = {
      float = {
        padding = 4,
        max_width = 100,
        border = 'rounded',
        get_win_title = function() return '' end, -- タイトルはwinbarで表示するのでボーダー上は消す
        override = function(conf)
          -- overrideはfloatを開くたびに呼ばれるのでここでbackdropを出す
          -- (FileType autocmdだとバッファ再利用時に発火しない)
          vim.schedule(function()
            local win = vim.api.nvim_get_current_win()
            local cfg = vim.api.nvim_win_get_config(win)
            if cfg.relative ~= '' then
              require('backdrop').show(win, cfg.zindex or 50)
            end
          end)
          return conf
        end,
        win_options = {
          winbar = ' %{v:lua.OilWinbar()}',
          winhighlight = 'WinBar:NormalFloat',
        },
      },
      view_options = { show_hidden = true },
      keymaps = {
        ['q'] = 'actions.close',
      },
    },
    init = function()
      function _G.OilWinbar()
        local dir = require('oil').get_current_dir()
        if not dir then return '' end
        return vim.fn.fnamemodify(dir, ':~')
      end

      vim.keymap.set('n', '<leader>s', '<cmd>Oil --float<CR>')
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          vim.keymap.set('n', '<leader><cr>', ':w<CR>', { buffer = true })
        end
      })
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
