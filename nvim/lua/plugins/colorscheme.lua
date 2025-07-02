return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'onedark'.setup {
        style = 'deep',
      }

      -- カラースキームが未設定ならonedarkに設定
      local current_colorscheme = vim.g.colors_name
      if current_colorscheme == nil or current_colorscheme == '' then
        require 'onedark'.load()
      end
    end
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
  },
}
