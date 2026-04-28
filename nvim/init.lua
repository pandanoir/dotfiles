---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end
vim.cmd.colorscheme 'mydefault'

require 'options'
require 'disable-providers'
require 'keymappings'
require 'setup-lazynvim'
require 'setup-completion'
require 'setup-lsp'
require 'use-extui'
require 'show-lsp-progress'
