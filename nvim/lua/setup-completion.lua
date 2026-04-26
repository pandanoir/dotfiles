-- Neovim 0.12+ のネイティブ補完の設定
-- 0.11以下では何もしない（plugins/completion.lua の nvim-cmp が動作する）
if not require('env').has_native_completion then return end

local function set_default_pumstyle()
  vim.o.pumborder = 'rounded'
  vim.o.pumblend = 10
  vim.o.pumheight = 15
end
set_default_pumstyle()
-- コマンドラインではpopup menuのボーダーを消す
vim.api.nvim_create_autocmd('CmdlineEnter', {
  callback = function()
    vim.o.pumborder = 'none'
    vim.o.pumblend = 0
  end,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
  callback = set_default_pumstyle,
})
vim.opt.autocomplete = true
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

-- 候補をkindごとにシンタックスハイライト
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
local function set_kind_highlights()
  for kind, color in pairs(kind_colors) do
    vim.api.nvim_set_hl(0, 'PmenuKind' .. kind, { fg = color, default = true })
  end
end

-- HACK: vim.lsp.completion が kind_hlgroup を Color 以外で設定しないため、
-- vim.fn.complete をラップして kind_hlgroup を自動注入する
-- また、abbr が長すぎる場合は切り詰めて kind カラムが見切れないようにする
local pum_abbr_max = 30
local orig_complete = vim.fn.complete
---@diagnostic disable-next-line: duplicate-set-field
vim.fn.complete = function(startcol, items)
  if type(items) == 'table' then
    for _, item in ipairs(items) do
      if type(item) == 'table' then
        if item.kind and not item.kind_hlgroup and kind_colors[item.kind] then
          item.kind_hlgroup = 'PmenuKind' .. item.kind
        end
        -- abbr（表示テキスト）を切り詰める（word はそのまま）
        local display = item.abbr or item.word
        if display and vim.fn.strcharlen(display) > pum_abbr_max then
          item.abbr = vim.fn.strcharpart(display, 0, pum_abbr_max - 1) .. '…'
        end
      end
    end
  end
  return orig_complete(startcol, items)
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
---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim__complete_set = function(...)
  local result = orig_complete_set(...)
  if result and result.winid then
    pcall(vim.api.nvim_win_set_config, result.winid, { border = 'rounded' })
    pcall(vim.api.nvim_set_option_value, 'winblend', 10, { win = result.winid })
  end
  return result
end

-- snacks.nvim input や Telescope prompt では自動補完を無効化
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'snacks_input', 'snacks_picker_input' },
  callback = function()
    vim.opt_local.autocomplete = false
  end,
})

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
