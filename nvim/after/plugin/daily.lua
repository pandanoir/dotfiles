if vim.env.NVIM_APPNAME ~= 'nvim-memo' then
  return
end

-- 以下日報用の設定
local function get_weekdays()
  local today = os.date('*t')
  local month = today.month
  local year = today.year

  local res = {}
  for i = 1, 31 do
    local d = os.time({ year = year, month = month, day = i, hour = 0, min = 0, sec = 0 })
    local d_table = os.date('*t', d) -- 日付をテーブル形式に変換

    -- 月が変わった場合はループを終了
    if d_table.month ~= month then break end

    -- 週末の場合はスキップ
    if d_table.wday == 1 or d_table.wday == 7 then
      goto continue
    end

    -- 結果をフォーマットしてリストに追加
    table.insert(res, string.format('# %d/%d/%d(%s)',
      d_table.year, d_table.month, d_table.day,
      ({ '日', '月', '火', '水', '木', '金', '土' })[d_table.wday]))

    ::continue::
  end

  -- 結果を逆順に並べ替え
  local result = {}
  for i = #res, 1, -1 do
    table.insert(result, res[i])
  end

  return table.concat(result, '\n') -- 結果を結合して返す
end

local dir = os.getenv('HOME') .. os.date('/Documents/daily-report/%Y')
local filename = os.date('%m.md')
local filepath = dir .. '/' .. filename

-- 今月の日報ファイルが存在しなければ作成する
os.execute('mkdir -p ' .. dir)
local file = io.open(filepath, 'r')
if file then
  file:close()
else
  file = io.open(filepath, 'w')
  if file then
    file:write('# 今月やってること\n')
    file:write(get_weekdays())
    file:close()
  end
end

-- 日報ファイルを開く
vim.cmd('e ' .. dir .. '/' .. filename)

-- 今日の日付の行にnマークをつける
local date_table = os.date('*t')
vim.fn.search(string.format('%d/%d/%d(', date_table.year, date_table.month, date_table.day))
vim.cmd [[normal mn]]

-- 昨日の日付の行にyマークをつける
if vim.fn.search(string.format('%d/%d', date_table.year, date_table.month), 'W') ~= 0 then
  vim.cmd [[normal my]]
end

-- 今日の日付の位置にジャンプ
vim.cmd [[normal `n]]

vim.cmd [[inoreabbrev <expr> nn "昼" .. strftime("%H:%M")]]
vim.cmd.colorscheme 'catppuccin'
