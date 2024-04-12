return {
  'nvim-tree/nvim-tree.lua',
  init = function()
    vim.keymap.set('n', '<leader>s', ':<C-u>NvimTreeToggle<CR>')
  end,
  opts = {
    hijack_netrw = true,
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
