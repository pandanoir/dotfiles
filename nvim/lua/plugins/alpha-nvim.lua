return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  keys = { { '<leader>,', ':<C-u>Alpha<CR>', desc = 'open alpha-nvim' } },
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    vim.cmd [[command! EditTempFile lua EditTempFile()]]
    function EditTempFile()
      local handle = io.popen('date +%Y-%m-%d')
      local filepath = '/tmp/' .. handle:read('*a'):gsub('%s+', '') .. '.txt'
      handle:close()

      vim.cmd('e ' .. filepath)
    end

    dashboard.section.buttons.val = {
      dashboard.button('o', ' ' .. ' Oil', ':Oil --float<cr>'),
      dashboard.button('f', ' ' .. ' Find file', '<cmd> Telescope find_files <cr>'),
      dashboard.button('i', ' ' .. ' New file', '<cmd> ene <BAR> startinsert <cr>'),
      dashboard.button('t', ' ' .. ' Edit temp file', '<cmd> EditTempFile <cr>'),
      dashboard.button('r', ' ' .. ' Recent files', '<cmd> Telescope oldfiles <cr>'),
      dashboard.button('g', ' ' .. ' Find text', '<cmd> Telescope live_grep <cr>'),
      dashboard.button('l', '󰒲 ' .. ' Lazy', '<cmd> Lazy <cr>'),
      dashboard.button('h', ' ' .. ' Check health', '<cmd> checkhealth <cr>'),
      dashboard.button('q', ' ' .. ' Quit', '<cmd> qa <cr>'),
    }
    dashboard.section.header.val = require 'ascii'.art.text.neovim.sharp

    local function footer()
      local total_plugins = #vim.tbl_keys(require 'lazy'.plugins())
      local datetime = os.date(' %Y-%m-%d   %H:%M:%S')
      local version = vim.version()
      local version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
      return datetime .. '  ⚡' .. total_plugins .. ' plugins' .. version_info
    end
    dashboard.section.footer.val = footer()

    return dashboard.opts
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'MaximilianLloyd/ascii.nvim'
  },
}
