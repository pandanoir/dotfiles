-- Neovim 0.12+ のネイティブ補完設定
-- 0.11以下では何もしない（plugins/completion.lua の nvim-cmp が動作する）
if not require('env').has_native_completion then return end

-- popup menuのborder（0.12 で追加）
vim.o.pumborder = 'rounded'
vim.o.pumblend = 10
vim.o.pumheight = 15
vim.opt.autocomplete = true
-- fuzzy: 曖昧マッチ / popup: 候補の説明をpopupで表示
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }

-- LSPの補完を自動で有効化
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- ポップアップメニューの基本ハイライト（カラースキームを尊重）
local function set_pum_highlights()
  local opts = { default = true }
  vim.api.nvim_set_hl(0, 'PmenuSbar', vim.tbl_extend('force', opts, { bg = '#313244' }))
  vim.api.nvim_set_hl(0, 'PmenuThumb', vim.tbl_extend('force', opts, { bg = '#585b70' }))
  vim.api.nvim_set_hl(0, 'PmenuMatch', vim.tbl_extend('force', opts, { fg = '#f9e2af', bold = true }))
  vim.api.nvim_set_hl(0, 'PmenuMatchSel', vim.tbl_extend('force', opts, { fg = '#f9e2af', bold = true }))
end

-- 候補をkindごとにシンタックスハイライト（カラースキームを尊重）
local function set_kind_highlights()
  local kind_colors = {
    Function    = '#82AAFF',
    Method      = '#82AAFF',
    Constructor = '#82AAFF',
    Variable    = '#C792EA',
    Field       = '#F78C6C',
    Property    = '#F78C6C',
    Constant    = '#F78C6C',
    EnumMember  = '#F78C6C',
    Class       = '#FFCB6B',
    Interface   = '#FFCB6B',
    Struct      = '#FFCB6B',
    Enum        = '#FFCB6B',
    Module      = '#89DDFF',
    File        = '#89DDFF',
    Folder      = '#FFCB6B',
    Keyword     = '#FF5370',
    Operator    = '#FF5370',
    Snippet     = '#C3E88D',
    Text        = '#EEFFFF',
  }
  for kind, color in pairs(kind_colors) do
    vim.api.nvim_set_hl(0, 'PmenuKind' .. kind, { fg = color, default = true })
  end
end

set_pum_highlights()
set_kind_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    set_pum_highlights()
    set_kind_highlights()
  end,
})

-- HACK: ドキュメントポップアップに無理やりボーダーを付ける
-- 現状 winborder や completeopt=popup だけではドキュメントfloatのボーダーを制御できない
-- https://github.com/neovim/neovim/issues/38248
-- 将来的に completepopup オプション等が実装されればこのワークアラウンドは不要になる
-- (この手法は deathbeam/autocomplete.nvim や neovim/neovim#29225 でも使われている)
local orig_complete_set = vim.api.nvim__complete_set
vim.api.nvim__complete_set = function(...)
  local result = orig_complete_set(...)
  if result and result.winid and vim.api.nvim_win_is_valid(result.winid) then
    pcall(vim.api.nvim_win_set_config, result.winid, { border = 'rounded' })
  end
  return result
end

-- 補完メニュー操作キーマップ（既存のnvim-cmp設定に合わせる）
local function expr_pum(pum_action, fallback)
  return function()
    return vim.fn.pumvisible() == 1 and pum_action or fallback
  end
end
vim.keymap.set('i', '<Tab>', expr_pum('<C-n>', '<Tab>'), { expr = true })
vim.keymap.set('i', '<S-Tab>', expr_pum('<C-p>', '<S-Tab>'), { expr = true })
vim.keymap.set('i', '<CR>', expr_pum('<C-y>', '<CR>'), { expr = true })

-- ファイル補完を確定した直後、カーソル直前が `/` ならディレクトリを掘り下げたい
-- はずなので <C-x><C-f> を再トリガ、そうでなければ（ファイル名確定）継続しない
vim.api.nvim_create_autocmd('CompleteDone', {
  callback = function()
    if vim.v.event.complete_type ~= 'files' or vim.v.event.reason ~= 'accept' then
      return
    end
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if line:sub(col, col) ~= '/' then
      return
    end
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<C-x><C-f>', true, false, true),
      'n', false
    )
  end,
})
