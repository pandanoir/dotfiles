return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  opts = {
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
  init = function()
    vim.o.cmdheight = 0
    vim.cmd [[
    autocmd RecordingEnter * set cmdheight=1
    autocmd RecordingLeave * set cmdheight=0
    ]]
  end
}
