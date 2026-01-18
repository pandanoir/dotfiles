-- no_plugin_maps = 1 の場合 macros/less.sh で起動したとみなす
local is_readonly = vim.bo.readonly or vim.g.no_plugin_maps == 1

return {
  { -- 行末の空白をハイライト
    'bronson/vim-trailing-whitespace',
    event = 'BufRead',
  },
  { -- カーソル行をモードに応じて装飾する
    'mvllow/modes.nvim',
    opts = function()
      return {
        line_opacity = {
          copy = 0.4,
          delete = 0.4,
          insert = 0.2,
          visual = 0.4,
        },
      }
    end,
  },
  -- lazygit と組み合わせると崩れるのでコメントアウト
  -- {
  --   'rbtnn/vim-ambiwidth',
  --   init = function()
  --     vim.g.ambiwidth_cica_enabled = false
  --   end
  -- },
  { -- sign columnにマークを表示
    'chentoast/marks.nvim',
    event = 'BufRead',
    opts = {
      builtin_marks = { '.', '^' },
      excluded_buftypes = { 'nofile', 'terminal' },
    },
  },
  { -- sign columnにGitの変更状況を表示
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = true,
  },
  { -- 折りたたみ行をシンタックスハイライトしたり、LSPのfolding rangeを利用して折り畳めるようにするプラグイン
    'kevinhwang91/nvim-ufo',
    event = 'BufRead',
    dependencies = 'kevinhwang91/promise-async',
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end
    },
    init = function()
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require 'ufo'.openAllFolds)
      vim.keymap.set('n', 'zM', require 'ufo'.closeAllFolds)
    end
  },
  { -- チャンクとインデントの可視化
    'shellRaining/hlchunk.nvim',
    event = 'BufRead',
    opts = {
      chunk = { enable = true },
      indent = { enable = true },
    },
  },
  { -- ステータスライン
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    opts = function()
      local empty = require('lualine.component'):extend()
      function empty:draw(default_highlight)
        self.status = ''
        self.applied_separator = ''
        self:apply_highlights(default_highlight)
        self:apply_section_separators()
        return self.status
      end

      local colors = {
        grey = '#333344',
      }

      -- Put proper separators and gaps between components in sections
      local function process_sections(sections)
        for name, section in pairs(sections) do
          local left = name:sub(9, 10) < 'x'
          for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
            table.insert(section, pos * 2, { empty, color = { fg = colors.grey, bg = colors.grey } })
          end
          for id, comp in ipairs(section) do
            if type(comp) ~= 'table' then
              comp = { comp }
              section[id] = comp
            end
            comp.separator = left and { right = '' } or { left = '' }
          end
        end
        return sections
      end

      return {
        options = {
          component_separators = '',
          section_separators = { left = '', right = '' },
        },
        sections = process_sections {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            {
              'diagnostics',
              source = { 'nvim' },
              sections = { 'error' },
            },
            {
              'diagnostics',
              source = { 'nvim' },
              sections = { 'warn' },
            },
            { 'filename', file_status = false },
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'filetype' },
          lualine_z = { '%l:%c', '%p%%/%L' },
        },
        inactive_sections = {
          lualine_c = { '%f %y %m' },
          lualine_x = {},
        },
      }
    end,
  },
  { -- LSPの進捗表示
    'j-hui/fidget.nvim',
    event = 'BufRead',
    cond = not is_readonly,
    config = true,
  },
  { -- 何件マッチしたか、マッチしたインスタンスが全体の何番目かをカーソル位置に表示
    'kevinhwang91/nvim-hlslens',
    init = function()
      local map = function(key, command)
        vim.keymap.set(
          'n',
          key,
          command .. "<Cmd>lua require('hlslens').start()<CR>",
          { silent = true }
        )
      end
      map('n', "<Cmd>execute('normal! '.v:count1.'n')<CR>")
      map('N', "<Cmd>execute('normal! '.v:count1.'N')<CR>")
      map('*', '*')
      map('#', '#')
      map('g*', 'g*')
      map('g#', 'g#')
    end,
    event = 'FilterWritePre',
    opts = {
      nearest_only = true,
    },
  },
  { -- ウィンドウ上部にファイル名を表示
    'b0o/incline.nvim',
    opts = {
      window = {
        padding = 0,
        margin = { horizontal = 0 },
        options = { winblend = 50 },
      },
      render = function(props)
        local helpers = require 'incline.helpers'
        local devicons = require 'nvim-web-devicons'
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if filename == '' then
          filename = '[No Name]'
        end

        local ft_icon, ft_color = devicons.get_icon_color(filename)
        if not ft_icon then
          return {
            {
              { ' ', filename, ' ' },
              gui = 'bold',
              guibg = '#44406e',
              blend = props.focused and 0 or 50,
            },
          }
        end

        return {
          {
            { ' ', ft_icon, ' ' },
            guibg = ft_color,
            guifg = helpers.contrast_color(ft_color),
            blend = props.focused and 0 or 50,
          },
          {
            { ' ', filename, ' ' },
            guibg = '#44406e',
            blend = props.focused and 0 or 50,
            gui = 'bold',
          },
        }
      end,
    },
    init = function()
      vim.o.laststatus = 3
    end,
    event = 'VeryLazy',
  },
  { -- ターミナル統合
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    init = function()
      local Terminal = require 'toggleterm.terminal'.Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        direction = 'float',
        hidden = true
      }

      vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { silent = true, desc = 'open lazygit' })

      local terminal = Terminal:new {
        direction = 'float',
        on_open = function(term) term:set_mode('i') end,
      }
      vim.keymap.set('n', "<leader>'", function() terminal:toggle() end, { silent = true, desc = 'open terminal' })
    end
  },
  { -- TODOコメントのハイライトと検索
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
  { -- カーソル行のすべての単語の一意な文字をハイライトして、fやFなどで素早く移動できるようにするプラグイン
    'unblevable/quick-scope',
    init = function()
      vim.keymap.set('n', '<leader><tab>q', '<cmd>QuickScopeToggle<cr>', { desc = 'toggle quick-scope' })
    end,
  },
  { -- quickfixのUIを改善
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module 'quicker'
    ---@type quicker.SetupOptions
    opts = {},
  },
  { -- 対応する括弧のマッチング強化
    'andymass/vim-matchup',
    init = function()
      vim.opt.matchpairs:append {
        '<:>', '「:」', '（:）', '『:』', '【:】', '《:》',
        '〈:〉', '｛:｝', '［:］', '‘:’', '“:”',
      }

      require 'easy-setup-autocmd'.setup_autocmd {
        ['ColorScheme'] = {
          pattern = '*',
          callback = function()
            vim.cmd [[
              hi MatchParen  guifg=#b58900
              hi MatchWord  guifg=#b58900
            ]]
          end
        }
      }
    end,
    opts = {
      treesitter = {
        stopline = 500,
      }
    }
  },
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
