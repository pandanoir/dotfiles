return {
  {
    'bronson/vim-trailing-whitespace',
    event = 'BufRead',
  },
  -- lazygit と組み合わせると崩れるのでコメントアウト
  -- {
  --   'rbtnn/vim-ambiwidth',
  --   init = function()
  --     vim.g.ambiwidth_cica_enabled = false
  --   end
  -- },
  {
    'chentoast/marks.nvim',
    event = 'BufRead',
    opts = {
      builtin_marks = { '.', '^' },
      excluded_buftypes = { 'nofile', 'terminal' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = true,
  },
  {
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
  {
    'shellRaining/hlchunk.nvim',
    event = 'BufRead',
    opts = {
      chunk = { enable = true },
      indent = { enable = true },
    },
  },
  {
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
  {
    'navarasu/onedark.nvim',
    init = function()
      vim.cmd.colorscheme 'onedark'
    end,
    opts = {
      style = 'cool'
    },
  },
  {
    'j-hui/fidget.nvim',
    event = 'BufRead',
    -- no_plugin_maps = 1 の場合 macros/less.sh で起動したとみなす
    cond = not vim.bo.readonly and vim.g.no_plugin_maps ~= 1,
    config = true,
  },
  {
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
      nearest_only = true
    },
  },
  {
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
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    init = function()
      local Terminal = require 'toggleterm.terminal'.Terminal
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        direction = 'float',
        hidden = true
      })

      vim.keymap.set('n', '<leader>g', function() lazygit:toggle() end, { silent = true })
    end
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      window = {
        width = 32,
        mappings = {
          ['<leader>t'] = 'close_window',
        },
      },
    },
    init = function()
      vim.keymap.set('n', '<leader>t', '<cmd>Neotree reveal<cr>')
      require 'easy-setup-autocmd'.setup_autocmd {
        ['UiEnter'] = {
          callback = function()
            local win_width = vim.api.nvim_win_get_width(0)

            -- git commit --amend のときは表示しない
            for _, arg in ipairs(vim.v.argv) do
              if arg:match('%.git/COMMIT_EDITMSG$') then
                return
              end
            end

            if win_width < 100 or vim.fn.argc() == 0 then
              return
            end

            local current_win = vim.api.nvim_get_current_win()
            vim.cmd [[Neotree reveal_force_cwd]]
            vim.api.nvim_set_current_win(current_win)
          end,
        }
      }
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
}
