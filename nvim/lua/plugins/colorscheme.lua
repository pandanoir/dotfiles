return {
  'folke/tokyonight.nvim',
  init = function()
    vim.cmd [[colorscheme tokyonight]]
  end,
  opts = {
    style = 'night',
  },
}
