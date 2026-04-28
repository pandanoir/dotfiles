-- nvr (neovim-remote) で開いたバッファの設定
-- toggletermを隠してから開き、バッファ終了時に復元する
local function setup_buf()
  vim.bo.bufhidden = 'wipe'
  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = 0,
    once = true,
    callback = function()
      vim.schedule(function()
        vim.cmd 'ToggleTermToggleAll'
      end)
    end,
  })
end

return { setup_buf = setup_buf }
