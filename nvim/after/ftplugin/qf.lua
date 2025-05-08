-- quickfixウィンドウだけが画面に残ってたら終了する
vim.api.nvim_create_autocmd('BufEnter', {
  buffer = 0,
  callback = function()
    if vim.bo.buftype ~= 'quickfix' then
      return
    end

    -- 通常のファイルウィンドウが残ってるか確認
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_get_option_value('buftype', { buf = vim.api.nvim_win_get_buf(win) }) == "" then
        return
      end
    end

    -- 通常ウィンドウがゼロの場合だけ Quickfix を閉じる
    vim.cmd('q')
  end,
})
