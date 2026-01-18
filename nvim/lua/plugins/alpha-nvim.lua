return {
  { -- スタートアップダッシュボード
    'goolord/alpha-nvim',
    event = 'VimEnter',
    keys = { { '<leader>,', ':<C-u>Alpha<CR>', desc = 'open alpha-nvim' } },
    opts = function()
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.buttons.val = {
        dashboard.button('i', ' ' .. ' New file', '<cmd> ene <BAR> startinsert <cr>'),
        dashboard.button('r', ' ' .. ' Recent files', '<cmd> Telescope oldfiles <cr>'),
        dashboard.button('l', ' ' .. ' Lazy', '<cmd> Lazy <cr>'),
        dashboard.button('h', ' ' .. ' Check health', '<cmd> checkhealth <cr>'),
        dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <cr>'),
      }
      dashboard.section.header.val = require 'ascii'.art.text.neovim.sharp

      local function footer()
        local total_plugins = #vim.tbl_keys(require 'lazy'.plugins())
        local version = vim.version()
        local version_info = version.major .. '.' .. version.minor .. '.' .. version.patch
        if version.prerelease and #version.prerelease > 0 then
          version_info = version_info .. "-" .. version.prerelease
        end
        return '⚡' .. total_plugins .. ' plugins   v' .. version_info
      end
      dashboard.section.footer.val = footer()

      dashboard.config.layout[1].val = 5
      dashboard.config.layout[3].val = 5
      return dashboard.config
    end,
    dependencies = {
      'MaximilianLloyd/ascii.nvim'
    },
  },
}
