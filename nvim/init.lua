---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end

require 'options'
require 'disable-providers'
require 'keymappings'
require 'setup-lazynvim'
require 'use-extui'

vim.cmd.colorscheme 'onedark'
