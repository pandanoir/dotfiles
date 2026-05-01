vim.opt.cursorline = true
vim.opt.bg = 'dark'
vim.opt.signcolumn = 'yes:3'

-- extuiが使えたら設定する
local ok, extui = pcall(require, 'vim._core.ui2')
if not ok then return end

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

-- 古いメッセージほど暗くするfade用のハイライト/描画
local fade_ns = vim.api.nvim_create_namespace('msg_fade')

local function setup_fade_hl()
  local function hl(name, attr)
    return vim.api.nvim_get_hl(0, { name = name, link = false })[attr]
  end
  local fg = hl('Normal', 'fg') or hl('NormalFloat', 'fg')
  local bg = hl('NormalFloat', 'bg') or hl('Normal', 'bg')
  if not (fg and bg) then return end
  for i, alpha in ipairs({ 0.55, 0.35, 0.2 }) do
    local function mix(s)
      local f, b = math.floor(fg / 2 ^ s) % 256, math.floor(bg / 2 ^ s) % 256
      return math.floor(f * alpha + b * (1 - alpha))
    end
    vim.api.nvim_set_hl(0, 'MsgFade' .. i, {
      fg = string.format('#%02x%02x%02x', mix(16), mix(8), mix(0)),
    })
  end
end
setup_fade_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = setup_fade_hl })

-- 最終行(最新)はそのまま、上にいくほど MsgFade1→2→3 で暗くする
local function refade(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  local n = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_buf_clear_namespace(buf, fade_ns, 0, -1)
  for i = 0, n - 1 do
    local age = math.min(n - 1 - i, 3)
    if age >= 1 then
      vim.api.nvim_buf_set_extmark(buf, fade_ns, i, 0, {
        end_row = i + 1,
        hl_group = 'MsgFade' .. age,
        hl_eol = true,
        priority = 250, -- ErrorMsg等の既存色より上にかぶせる
      })
    end
  end
end

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

    -- buf変更のたびにfadeを張り直す
    if not vim.b[ev.buf].msg_fade_attached then
      vim.b[ev.buf].msg_fade_attached = true
      vim.api.nvim_buf_attach(ev.buf, false, {
        on_lines = function() vim.schedule(function() refade(ev.buf) end) end,
      })
      refade(ev.buf)
    end
  end,
})

-- ステータスバーを削除
vim.o.cmdheight = 0
vim.o.laststatus = 0
vim.o.showmode = false
vim.o.ruler = false
