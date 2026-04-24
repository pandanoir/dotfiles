-- mydefault.lua — Neovim default をベースに、色被りを分離したカラースキーム
vim.cmd('hi clear')
vim.g.colors_name = 'mydefault'

-- パレット定義
local c = {
  -- デフォルトから引き継ぎ
  fg        = '#e0e2ea', -- NvimLightGrey2
  bg        = '#14161b', -- NvimDarkGrey2
  comment   = '#9b9ea4', -- NvimLightGrey4
  string    = '#b3f6c0', -- NvimLightGreen
  ident     = '#a6dbff', -- NvimLightBlue
  func      = '#84e2e1', -- NvimLightCyan

  -- 分離用の新しい色 (デフォルトパレットの色を活用)
  keyword   = '#a8afc7', -- 青みがかったグレー (控えめ) → キーワード
  constant  = '#ffcaff', -- NvimLightMagenta → 定数・数値
  type      = '#a0d8b0', -- 薄いミントグリーン (italic で分離)
  preproc   = '#c4b5fc', -- 薄紫 (LightBlue と LightMagenta の中間)
  special   = '#84e2e1', -- NvimLightCyan → Special (デフォルトと同じ)
  operator  = '#c4c6cd', -- NvimLightGrey3 → 少し暗め
  delimiter = '#9b9ea4', -- NvimLightGrey4 → コメントと同程度
}

-- デフォルトの色数が少なすぎるので追加
local hi = vim.api.nvim_set_hl
hi(0, 'Comment', { fg = c.comment, italic = true })
hi(0, 'Constant', { fg = c.constant })
hi(0, 'String', { fg = c.string })
hi(0, 'Identifier', { fg = c.ident })
hi(0, 'Function', { fg = c.func })
hi(0, 'Statement', { fg = c.keyword, bold = true })
hi(0, 'PreProc', { fg = c.preproc })
hi(0, 'Type', { fg = c.type, italic = true })
hi(0, 'Special', { fg = c.special })
hi(0, 'Operator', { fg = c.operator })
hi(0, 'Delimiter', { fg = c.delimiter })
hi(0, 'Todo', { fg = c.keyword, bold = true })
hi(0, 'Underlined', { fg = c.ident, underline = true })
hi(0, 'Error', { fg = '#eef1f8', bg = '#590008' })
hi(0, 'Ignore', { link = 'Normal' })

-- Treesitter系
-- tsx
hi(0, '@tag.attribute.tsx', { link = 'Identifier' })
hi(0, '@tag.delimiter.tsx', { link = 'Delimiter' })
hi(0, '@keyword.operator.tsx', { link = 'Identifier' })
-- typescript
hi(0, '@keyword.operator.typescript', { link = 'Identifier' })
