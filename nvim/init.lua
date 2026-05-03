---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end
vim.cmd.colorscheme 'mydefault'

-- test 2

require 'disable-providers'
require 'register-filetype'
require 'options'
require 'optimize-largefile'
require 'setup-indent'
require 'setup-keymappings'
require 'setup-completion'
require 'setup-ui'
require 'setup-lsp'
require 'setup-lazynvim'
require 'show-lsp-progress'
