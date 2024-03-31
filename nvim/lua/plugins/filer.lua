return {
  'nvim-tree/nvim-tree.lua',
  cmd = 'NvimTreeToggle',
  keys = { { '<leader>s', ':<C-u>NvimTreeToggle<CR>' } },
  init = function()
    -- disable netrw at the very start of your init.lua (strongly advised)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true
  end,
  opts = {
    update_focused_file = {
      enable = true,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  },
}
