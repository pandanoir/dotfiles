return {
  'folke/tokyonight.nvim',
  init = function()
    vim.g.tokyonight_style = 'night'
    vim.g.tokyonight_transparent_background = 1
    vim.cmd [[colorscheme tokyonight]]
  end
}
