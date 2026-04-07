-- extuiが使えたら設定する
local ok, extui = pcall(require, 'vim._core.ui2')
if ok then
  extui.enable {
    msg = {
      targets = {
        -- 既定: 軽い通知系は msg ポップアップへ
        ['']          = 'msg',

        -- 折り畳まれたら困るやつは pager に流す
        list_cmd      = 'pager', -- :ls, :set all, :map, :marks 等
        lua_error     = 'pager',
        rpc_error     = 'pager',
        shell_out     = 'pager', -- :! の出力
        shell_err     = 'pager',

        -- 検索や入力中の表示は cmdline で見たい
        search_cmd    = 'cmd',
        search_count  = 'cmd',
        confirm       = 'cmd',
        return_prompt = 'cmd',
      },
      cmd     = { height = 0.5 },
      msg     = { height = 0.3, timeout = 4000 },
      pager   = { height = 0.75 },
      dialog  = { height = 0.5 },
    },
  }

  -- msg を装飾
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'msg',
    callback = function(ev)
      local win = vim.fn.bufwinid(ev.buf)
      if win == -1 then return end
      pcall(vim.api.nvim_win_set_config, win, {
        border = 'rounded', -- 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
      })
      vim.wo[win].winhighlight = table.concat({
        'Normal:NormalFloat',
        'FloatBorder:DiagnosticInfo', -- border に色
        'Search:',                    -- 検索ハイライトを潰す
      }, ',')
      vim.wo[win].winblend = 10       -- 少し透過
      vim.wo[win].signcolumn = 'no'
      vim.wo[win].number = false
    end,
  })
end
