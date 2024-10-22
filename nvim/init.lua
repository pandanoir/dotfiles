---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end



require('options')
require('disable-providers')
require('keymappings')
require('install-lazynvim')
require('setup-lazynvim')
require('userautoload.indent')
require('userautoload.filetype')
