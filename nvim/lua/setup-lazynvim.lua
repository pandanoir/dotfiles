require 'install-lazynvim'

-- Any lua file in ~/.config/nvim/lua/plugins/*.lua will be automatically merged in the main plugin spec
require 'lazy'.setup('plugins', {
  change_detection = { notify = false },
  rocks = { enabled = false } -- TODO: deps関連を全部書き直す必要があるため、書き直しが終わったらtrueにする
})
