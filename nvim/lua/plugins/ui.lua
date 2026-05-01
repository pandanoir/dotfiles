return {
  { -- 行末の空白をハイライト
    'bronson/vim-trailing-whitespace',
    event = 'BufRead',
  },
  { -- カーソル行をモードに応じて装飾する
    'mvllow/modes.nvim',
    opts = {
      line_opacity = {
        copy = 0.4,
        delete = 0.4,
        insert = 0.2,
        visual = 0.4,
      },
    },
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
    opts = {
      preview_config = {
        border = 'rounded',
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r)
          vim.keymap.set(mode, l, r, { buffer = bufnr })
        end

        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
      end,
    }
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
    opts = function()
      local filter = function()
        return not vim.b.large_file
      end
      return {
        chunk = { enable = true, filter = filter },
        indent = { enable = true, filter = filter },
      }
    end,
  },
  { -- 検索時に全何件マッチしたか、何番目のマッチかをカーソル位置に表示
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
    cond = not require('env').from_claude,
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
  { -- コンテキストに応じたコメント文字列の設定
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'VeryLazy',
    opts = {
      enable_autocmd = false,
    },
    init = function()
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring'
            and require 'ts_context_commentstring.internal'.calculate_commentstring()
            or get_option(filetype, option)
      end
    end
  },
  { -- カーソル行のすべての単語の一意な文字をハイライトして、fやFなどで素早く移動できるようにするプラグイン
    'unblevable/quick-scope',
    init = function()
      vim.keymap.set('n', '<leader><tab>q', '<cmd>QuickScopeToggle<cr>', { desc = 'toggle quick-scope' })
    end,
  },
  { -- 小規模なUI改善プラグイン集。vim.ui.input/selectに使用
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
      input = {
        enabled = true,
        icon = '',
        win = {
          title_pos = 'left',
          relative = 'cursor',
          row = -3,
          col = 0,
          width = 20,
          keys = {
            fd = {
              'fd',
              function() vim.cmd('stopinsert') end,
              mode = 'i',
            },
          },
        },
      },
      picker = {
        enabled = true,
        ui_select = true,
        layouts = {
          select = {
            layout = {
              relative = 'cursor',
              width = 70,
              row = 1,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)

      -- HACK: :checkhealth snacks の不要なエラーを抑制する
      -- 1. disabledなプラグインは "setup {disabled}" だけ表示してhealth()をスキップ
      -- 2. picker の fd 関連エラーを抑制（fdを使わないため）
      local snacks_health = require('snacks.health')
      local orig_check = snacks_health.check
      snacks_health.check = function()
        local Snacks = require('snacks')
        local disabled = {}
        for _, p in ipairs(Snacks.meta.get()) do
          if p.meta.needs_setup and not (Snacks.config[p.name] or {}).enabled then
            disabled['Snacks.' .. p.name] = true
          end
        end

        local suppressing = false
        local orig = {}
        for _, k in ipairs({ 'start', 'ok', 'warn', 'error', 'info' }) do
          orig[k] = vim.health[k]
        end

        ---@diagnostic disable-next-line: duplicate-set-field
        vim.health.start = function(name, ...)
          suppressing = disabled[name] or false
          orig.start(name, ...)
          if suppressing then orig.warn('setup {disabled}') end
        end
        for _, k in ipairs({ 'ok', 'warn', 'error', 'info' }) do
          vim.health[k] = function(msg, ...)
            if suppressing then return end
            if type(msg) == 'string' and (msg:find("'fd'", 1, true) or msg:find("'fdfind'", 1, true)) then return end
            if k == 'error' and type(msg) == 'string' and msg:find('{lazygit}', 1, true) then return end
            -- headlessモードではUIEnterが発火せずvim.ui.input/selectが設定されないため抑制
            if k == 'error' and type(msg) == 'string' and msg:find('is not set to', 1, true) and #vim.api.nvim_list_uis() == 0 then return end
            return orig[k](msg, ...)
          end
        end

        orig_check()

        for k, fn in pairs(orig) do vim.health[k] = fn end
      end
    end,
  },
  { -- quickfixのUIを改善
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module 'quicker'
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          '>',
          function() require 'quicker'.expand { before = 2, after = 2, add_to_existing = true } end,
          desc = 'Expand quickfix context',
        },
        {
          '<',
          function() require 'quicker'.collapse() end,
          desc = 'Collapse quickfix context',
        },
      },
    },
  },
  { -- 対応する括弧のマッチング強化
    'andymass/vim-matchup',
    init = function()
      vim.opt.matchpairs:append {
        '<:>', '「:」', '（:）', '『:』', '【:】', '《:》',
        '〈:〉', '｛:｝', '［:］', '‘:’', '“:”',
      }

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.cmd [[
            hi MatchParen  guifg=#b58900
            hi MatchWord  guifg=#b58900
          ]]
        end
      })
    end,
    opts = {
      treesitter = {
        stopline = 500,
      }
    }
  },
}
