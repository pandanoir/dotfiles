return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  keys = { { '<leader>,', ':<C-u>Alpha<CR>' } },
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.buttons.val = {
      dashboard.button('t', '  nvim-tree', ':NvimTreeToggle<cr>'),
      dashboard.button('f', ' ' .. ' Find file', '<cmd> Telescope find_files <cr>'),
      dashboard.button('i', ' ' .. ' New file', '<cmd> ene <BAR> startinsert <cr>'),
      dashboard.button('r', ' ' .. ' Recent files', '<cmd> Telescope oldfiles <cr>'),
      dashboard.button('g', ' ' .. ' Find text', '<cmd> Telescope live_grep <cr>'),
      dashboard.button('l', '󰒲 ' .. ' Lazy', '<cmd> Lazy <cr>'),
      dashboard.button('h', ' ' .. ' Check health', '<cmd> checkhealth <cr>'),
      dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <cr>'),
    }

    local function footer()
      local total_plugins = #vim.tbl_keys(require 'lazy'.plugins())
      local datetime = os.date(' %Y-%m-%d   %H:%M:%S')
      local version = vim.version()
      local version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
      return datetime .. '  ⚡' .. total_plugins .. ' plugins' .. version_info
    end
    dashboard.section.footer.val = footer()

    return dashboard.opts
  end
}
