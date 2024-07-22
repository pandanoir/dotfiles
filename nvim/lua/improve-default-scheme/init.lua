local M = {}
function M.improve()
  if vim.api.nvim_exec('colorscheme', true) ~= 'default' then
    return
  end
  vim.cmd [[highlight Normal guibg=#191919]]
  -- tsx でのみ出てくる要素のハイライトを変更
  local highlight_links = {
    { "@tag.attribute.tsx", "Identifier" },
    { "@tag.delimiter.tsx", "Delimiter" },
  }
  for _, link in ipairs(highlight_links) do
    vim.cmd(string.format("highlight link %s %s", link[1], link[2]))
  end

  -- typescript でも出てくる要素のハイライトを変更
  highlight_links = {
    { "@keyword.inspect",   "Special" },
    { "@keyword.import",    "Special" },
    { "@keyword",           "Special" },
    { "@keyword.operator",  "Identifier" },
    { "@keyword.exception", "Special" },
  }
  for _, link in ipairs(highlight_links) do
    vim.cmd(string.format("highlight link %s.tsx %s", link[1], link[2]))
    vim.cmd(string.format("highlight link %s.typescript %s", link[1], link[2]))
  end
end

return M
