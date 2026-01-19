return {
  { -- キーバインドの候補を表示
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      defer = function(ctx)
        return vim.list_contains({ '<C-V>', 'V', 'v' }, ctx.mode)
      end,
      sort = {
        -- descの先頭についている[xxx]を元にソート
        function(item)
          local group = item.desc:match('^%[(.*)%]')
          return group and '0:' .. group or '1:'
        end,
        'local', 'order', 'group', 'alphanum', 'mod',
      },
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
        { '<c-w>h', desc = '[focus] Go to the left window', icon = '󰜱', },
        { '<c-w>j', desc = '[focus] Go to the down window', icon = '󰜮', },
        { '<c-w>k', desc = '[focus] Go to the up window', icon = '󰜷', },
        { '<c-w>l', desc = '[focus] Go to the right window', icon = '󰜴', },
        { '<c-w>w', desc = '[focus] Switch windows', icon = '', },
        { '<c-w>H', desc = '[move] Move window to far left', icon = { icon = '', color = 'green' }, },
        { '<c-w>J', desc = '[move] Move window to far bottom', icon = { icon = '', color = 'green' }, },
        { '<c-w>K', desc = '[move] Move window to far top', icon = { icon = '', color = 'green' }, },
        { '<c-w>L', desc = '[move] Move window to far right', icon = { icon = '', color = 'green' }, },
        { '<c-w>s', desc = '[split] Split window', icon = { icon = '󰤻', color = 'yellow' }, },
        { '<c-w>v', desc = '[split] Split window vertically', icon = { icon = '󰤼', color = 'yellow' }, },
        { '<c-w>q', desc = '[close] Quit a window', icon = { icon = '󰅖', color = 'red' }, },
        { '<c-w>o', desc = '[close] Close all other windows', icon = { icon = '󰅗', color = 'red' }, },
        { '<c-w>+', desc = '[size-h] Increase height', icon = { icon = '󰡏', color = 'purple' }, },
        { '<c-w>-', desc = '[size-h] Decrease height', icon = { icon = '󰡍', color = 'purple' }, },
        { '<c-w>_', desc = '[size-h] Max out the height', icon = { icon = '', color = 'purple' }, },
        { '<c-w>>', desc = '[size-w] Increase width', icon = { icon = '󰡎', color = 'purple' }, },
        { '<c-w><', desc = '[size-w] Decrease width', icon = { icon = '󰡌', color = 'purple' }, },
        { '<c-w>|', desc = '[size-w] Max out the width', icon = { icon = '', color = 'purple' }, },
        { '<c-w>T', desc = 'Break out into a new tab', icon = '󰓩', },
        { '<c-w>x', desc = 'Swap current with next', icon = '󰓡', },
        { '<c-w>d', desc = 'Show diagnostics under the cursor', icon = '', },
        { '<c-w>=', desc = 'Equally high and wide', icon = '', },

        -- z系
        { 'za', desc = '[fold] Toggle fold under cursor', icon = { icon = '', color = 'yellow' } },
        { 'zA', desc = '[fold] Toggle all folds under cursor', icon = { icon = '', color = 'yellow' } },
        { 'zi', desc = '[fold] Toggle folding', icon = { icon = '', color = 'yellow' } },
        { 'zc', desc = '[fold] Close fold under cursor', icon = { icon = '󰘕', color = 'red' } },
        { 'zo', desc = '[fold] Open fold under cursor', icon = { icon = '󰘖', color = 'cyan' } },
        { 'zd', desc = '[fold] Delete fold under cursor', icon = { icon = '󰁮', color = 'gray' } },
        { 'zf', desc = '[fold] Create fold', icon = { icon = '󰐕', color = 'gray' } },
        { 'zC', desc = '[fold] Close all folds under cursor', icon = { icon = '󰘕', color = 'red' } },
        { 'zO', desc = '[fold] Open all folds under cursor', icon = { icon = '󰘖', color = 'cyan' } },
        { 'zD', desc = '[fold] Delete all folds under cursor', icon = { icon = '󰁮', color = 'gray' } },
        { 'zE', desc = '[fold] Delete all folds in file', icon = { icon = '󰁮', color = 'gray' } },
        { 'zR', desc = '[foldlevel] Open all folds (set foldlevel=max)', icon = { icon = '󰘖', color = 'cyan' } },
        { 'zM', desc = '[foldlevel] Close all folds (set foldlevel=0)', icon = { icon = '󰘕', color = 'red' } },
        { 'zr', desc = '[foldlevel] Fold less (foldlevel +1)', icon = { icon = '󰝡', color = 'cyan' } },
        { 'zm', desc = '[foldlevel] Fold more (foldlevel -1)', icon = { icon = '󰝠', color = 'red' } },
        { 'zx', desc = '[foldlevel] Reapply folds (reset to foldlevel)', icon = { icon = '󰑐', color = 'yellow' } },
        { 'zb', desc = '[cursor] Bottom this line', icon = { icon = '󰝓', color = 'purple' } },
        { 'zt', desc = '[cursor] Top this line', icon = { icon = '󰝕', color = 'purple' } },
        { 'zz', desc = '[cursor] Center this line', icon = { icon = '󰝔', color = 'purple' } },

        -- g系
        { 'ga', icon = '󰊄', group = '[case] converting text case' },
        { 'gd', icon = '󰅬', desc = '[lsp] go to definition' },
        { 'gg', icon = '󰘀', desc = 'First line' },
        { 'gO', icon = '󰅬', desc = '[lsp] Lists all symbols in current buffer in location-list' },
        { 'gp', icon = '󰅬', desc = '[lsp] peek definition' },
        { 'gr', icon = '󰅬', group = '[lsp] LSP' },
        { 'gt', icon = '󰅬', desc = '[lsp] go to type definition' },
        { 'gu', icon = '󰊄', desc = '[case] Lowercase' },
        { 'gU', icon = '󰊄', desc = '[case] Uppercase' },
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
