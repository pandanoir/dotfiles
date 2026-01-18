return {
  { -- キーバインドの候補を表示
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      defer = function(ctx)
        return vim.list_contains({ '<C-V>', 'V', 'v' }, ctx.mode)
      end,
      sort = { 'alphanum', 'case', },
      spec = {
        { '<leader>g', icon = { icon = '', color = 'red', }, group = 'git', },
        { '<leader><tab>', group = 'toggle', },
        { '<leader>c', icon = '', },
        { '<leader>e', icon = '', },
        { '<leader>l', icon = '', },
        { '<leader>o', icon = '󰠶', },
        { '<leader>p', icon = '', },
        { '<leader>y', icon = '󰆏', },
        { '<leader>j', icon = '󱘖', },
        { '<leader>J', icon = '󱘖', },
        { '<leader>,', icon = '', },
        { '<leader><space>', name = 'enter blockwise visual mode', },
        {
          -- vim-visual-star-search
          '<leader>*',
          desc = 'search word or selection across project',
          mode = { 'n', 'v' },
        },

        -- ウィンドウ関連のキーマップ
        { '<c-w>h', icon = '󰜱', desc = 'Go to the left window', },
        { '<c-w>j', icon = '󰜮', desc = 'Go to the down window', },
        { '<c-w>k', icon = '󰜷', desc = 'Go to the up window', },
        { '<c-w>l', icon = '󰜴', desc = 'Go to the right window', },

        { '<c-w>H', icon = '', desc = 'Move window to far left' },
        { '<c-w>J', icon = '', desc = 'Move window to far bottom' },
        { '<c-w>K', icon = '', desc = 'Move window to far top' },
        { '<c-w>L', icon = '', desc = 'Move window to far right' },

        { '<c-w>s', icon = { icon = '󰤻', color = 'yellow' }, desc = 'Split window' },
        { '<c-w>v', icon = { icon = '󰤼', color = 'yellow' }, desc = 'Split window vertically' },
        { '<c-w>T', icon = { icon = '󰓩', color = 'yellow' }, desc = 'Break out into a new tab' },

        { '<c-w>w', icon = '', desc = 'Switch windows' },
        { '<c-w>x', icon = '󰓡', desc = 'Swap current with next' },

        { '<c-w>q', icon = { icon = '󰅖', color = 'red' }, desc = 'Quit a window' },
        { '<c-w>o', icon = { icon = '󰅗', color = 'red' }, desc = 'Close all other windows' },

        { '<c-w>+', icon = { icon = '󰡏', color = 'purple' }, desc = 'Increase height' },
        { '<c-w>-', icon = { icon = '󰡍', color = 'purple' }, desc = 'Decrease height' },
        { '<c-w>_', icon = { icon = '󰁌', color = 'purple' }, desc = 'Max out the height' },

        { '<c-w>>', icon = { icon = '󰡎', color = 'purple' }, desc = 'Increase width' },
        { '<c-w><', icon = { icon = '󰡌', color = 'purple' }, desc = 'Decrease width' },
        { '<c-w>|', icon = { icon = '󰁌', color = 'purple' }, desc = 'Max out the width' },

        { '<c-w>d', icon = '', desc = 'Show diagnostics under the cursor', },
        { '<c-w>=', icon = '', desc = 'Equally high and wide' },

        -- z系
        { 'za', icon = { icon = '', color = 'yellow', }, desc = 'Toggle fold under cursor', },
        { 'zA', icon = { icon = '', color = 'yellow', }, desc = 'Toggle all folds under cursor', },
        { 'zi', icon = { icon = '', color = 'yellow', }, desc = 'Toggle folding', },

        { 'zc', icon = { icon = '󰘕', color = 'yellow', }, desc = 'Close fold under cursor', },
        { 'zo', icon = { icon = '󰘖', color = 'yellow', }, desc = 'Open fold under cursor', },
        { 'zd', icon = { icon = '󰁮', color = 'red', }, desc = 'Delete fold under cursor', },
        { 'zf', icon = { icon = '󰐕', color = 'red', }, desc = 'Create fold', },

        { 'zC', icon = { icon = '󰘕', color = 'yellow', }, desc = 'Close all folds under cursor', },
        { 'zO', icon = { icon = '󰘖', color = 'yellow', }, desc = 'Open all folds under cursor', },
        { 'zD', icon = { icon = '󰁮', color = 'red', }, desc = 'Delete all folds under cursor', },
        { 'zE', icon = { icon = '󰁮', color = 'red', }, desc = 'Delete all folds in file', },
        { 'zR', icon = { icon = '󰘖', color = 'yellow', }, desc = 'Open all folds', },
        { 'zM', icon = { icon = '󰘕', color = 'yellow', }, desc = 'Close all folds', },

        { 'zr', icon = { icon = '󰝠', color = 'yellow', }, desc = 'Fold less', },
        { 'zm', icon = { icon = '󰝡', color = 'yellow', }, desc = 'Fold more', },
        { 'zx', icon = { icon = '󰑐', color = 'yellow', }, desc = 'Update folds', },

        { 'zb', icon = { icon = '󰝓', color = 'purple' }, desc = 'Bottom this line', },
        { 'zt', icon = { icon = '󰝕', color = 'purple' }, desc = 'Top this line', },
        { 'zz', icon = { icon = '󰝔', color = 'purple' }, desc = 'Center this line', },

        -- g系
        { 'ga', icon = '󰊄', group = 'converting text case' },
        { 'gd', icon = '󰅬', desc = 'go to definition' },
        { 'gg', icon = '󰘀', desc = 'First line' },
        { 'gO', icon = '󰅬', desc = 'Lists all symbols in current buffer in location-list' },
        { 'gp', icon = '󰅬', desc = 'peek definition' },
        { 'gr', icon = '󰅬', group = 'LSP' },
        { 'gt', icon = '󰅬', desc = 'go to type definition' },
        { 'gu', icon = '󰊄', desc = 'Lowercase' },
        { 'gU', icon = '󰊄', desc = 'Uppercase' },
        { 'gv', icon = '󰒉', desc = 'Last visual selection' },
        {
          'gf',
          function()
            local cfile = vim.fn.expand('<cfile>')
            print(cfile)
            if cfile:match('^https?://') then
              vim.fn.system { 'open', '-a', 'google chrome', cfile }
            else
              vim.cmd 'normal! gF'
            end
          end,
          icon = '',
          desc = 'Go to file under cursor',
        },
      },
    },
    init = function()
      local timeoutlen = 400
      vim.o.timeout = true
      vim.o.timeoutlen = timeoutlen

      require 'easy-setup-autocmd'.setup_autocmd {
        ['InsertEnter'] = {
          callback = function() vim.o.timeoutlen = 200 end,
        },
        ['InsertLeave'] = {
          callback = function() vim.o.timeoutlen = timeoutlen end,
        }
      }
    end,
  },
  { -- バッファ削除を改善
    'ojroques/nvim-bufdel',
  },
  { -- コンテキストに応じたファイルタイプ判定
    'Shougo/context_filetype.vim',
  },
}
