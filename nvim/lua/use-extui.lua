-- extuiが使えたら設定する
local ok, extui = pcall(require, 'vim._extui')
if ok then
  extui.enable {
    enable = true,
    msg = {
      target = 'cmd',
      timeout = 4000,
    },
  }
end
