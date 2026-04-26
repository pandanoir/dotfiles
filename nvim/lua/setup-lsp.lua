vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local map = vim.keymap.set
    local opt = function(desc)
      return { silent = true, buffer = ev.buf, desc = desc }
    end
    map('n', 'gd', vim.lsp.buf.definition, opt('go to definition'))
    map('n', 'gt', vim.lsp.buf.type_definition, opt('go to type definition'))
    map('n', 'grr', '<cmd>Telescope lsp_references<CR>', opt('find references'))
    map('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, opt())
    map('n', 'grn', vim.lsp.buf.rename, opt('rename using LSP'))
    map('n', 'gra', vim.lsp.buf.code_action, opt('open code action'))
  end
})

-- markdown floatにフォーカスしたらconcealを外して高さをテキスト量に合わせる
-- cf. https://github.com/neovim/neovim/issues/36537
vim.api.nvim_create_autocmd('WinEnter', {
  callback = function(ev)
    local win = vim.api.nvim_get_current_win()
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative == '' or vim.bo[ev.buf].filetype ~= 'markdown' then
      return
    end
    vim.wo[win].conceallevel = 0
    local new_height = math.min(vim.api.nvim_win_text_height(win, {}).all, math.floor(vim.o.lines * 0.8))
    if new_height ~= cfg.height then
      cfg.height = new_height
      vim.api.nvim_win_set_config(win, cfg)
    end
  end,
})

-- HACK: :checkhealth vim.lsp の "Unknown filetype" 警告を抑制
-- (nvim-lspconfigが未登録のfiletypeを多数含んでおりノイズになるため)
-- M.checkのupvalueにあるサブ関数それぞれの report_warn をパッチする
do
  local suppress = require('suppress-health')
  local lsp_health = require 'vim.lsp.health'
  for i = 1, math.huge do
    local name, val = debug.getupvalue(lsp_health.check, i)
    if not name then break end
    if type(val) == 'function' then
      suppress.suppress({ "Unknown filetype '" }, val)
    end
  end
end
