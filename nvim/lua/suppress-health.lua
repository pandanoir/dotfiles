-- :checkhealth の既知の無害な警告/エラーを抑制するユーティリティ
local M = {}

local health_reporters = nil
local function get_health_reporters()
  if not health_reporters then
    health_reporters = {}
    for _, k in ipairs({ 'ok', 'warn', 'error', 'info' }) do
      health_reporters[vim.health[k]] = true
    end
  end
  return health_reporters
end

--- health check の特定メッセージを抑制する。
--- プラグインが `local warn = vim.health.warn` のようにファイル先頭でキャプチャしている場合、
--- vim.health.warn を上書きしても効かないため debug.setupvalue で差し替える。
--- キャプチャされた変数は値が vim.health.* と一致するかで自動判別する。
---
--- @param patterns string[] 抑制するメッセージパターン（部分一致）
--- @param fn function パッチ対象の関数（health.check またはそのサブ関数）
function M.suppress(patterns, fn)
  local reporters = get_health_reporters()
  for i = 1, math.huge do
    local name, val = debug.getupvalue(fn, i)
    if not name then return end
    if reporters[val] then
      debug.setupvalue(fn, i, function(msg, ...)
        if type(msg) == 'string' then
          for _, p in ipairs(patterns) do
            if msg:find(p, 1, true) then return end
          end
        end
        return val(msg, ...)
      end)
    end
  end
end

return M
