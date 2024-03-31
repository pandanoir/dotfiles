return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  opts = {
    options = {
      theme = 'onedark',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
