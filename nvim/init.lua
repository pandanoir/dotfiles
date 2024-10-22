---@diagnostic disable-next-line: undefined-global
if vim.loader then vim.loader.enable() end



require('options')
require('disable-providers')
require('lazynvim')
require('keymappings')
require('userautoload.indent')
require('userautoload.filetype')
