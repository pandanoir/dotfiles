-- Neovim 0.12+ のネイティブ補完設定
-- 0.11以下では何もしない（plugins/completion.lua の nvim-cmp が動作する）
if not require('env').has_native_completion then return end

-- popup menuのborder（0.12 で追加）
vim.o.pumborder = 'rounded'
-- fuzzy: 曖昧マッチ / popup: 候補の説明をpopupで表示
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }

-- LSPの補完を自動で有効化
require 'easy-setup-autocmd'.setup_autocmd {
  ['LspAttach'] = {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  },
}

-- 候補をkindごとにシンタックスハイライト（PmenuKind* を上書き）
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
set_kind_highlights()
require 'easy-setup-autocmd'.setup_autocmd {
  ['ColorScheme'] = {
    pattern = '*',
    callback = set_kind_highlights,
  },
}

-- 候補の説明popupはネイティブだとborderが付かないので、CompleteChanged時に
-- window configを直接書き換えてborderを付ける
local function find_preview()
  local info = vim.fn.complete_info { 'preview_winid' }
  local winid = info.preview_winid
  if winid and winid > 0 and vim.api.nvim_win_is_valid(winid) then
    return winid
  end
  -- complete_info が preview_winid を返さない環境向けのフォールバック
  -- pumに紐づく無名の浮動windowを探す
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(w)
    if config.relative ~= '' then
      local b = vim.api.nvim_win_get_buf(w)
      if vim.api.nvim_buf_get_name(b) == '' and vim.bo[b].buftype == 'nofile' then
        return w
      end
    end
  end
end

-- CompleteChangedの直後(vim.schedule)にset_configしても、その後Neovim内部が
-- popup configを再適用してborderをnone等に戻してしまう。
-- 300ms待ってNeovim内部のpopup config適用が落ち着いてから border を付ける
require 'easy-setup-autocmd'.setup_autocmd {
  ['CompleteChanged'] = {
    callback = function()
      vim.defer_fn(function()
        local winid = find_preview()
        if winid then
          local ok, cfg = pcall(vim.api.nvim_win_get_config, winid)
          if ok then
            cfg.border = 'rounded'
            pcall(vim.api.nvim_win_set_config, winid, cfg)
          end
          vim.wo[winid].conceallevel = 2
          vim.wo[winid].concealcursor = 'n'
        end
      end, 300)
    end,
  },
}

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
