return {
  { -- シンタックスハイライトとテキストオブジェクト
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'css',
        'html',
        'json',
        'lua',
        'bash',
        'markdown_inline',
        'markdown',
        'scss',
        'toml',
        'vim',
        'vimdoc'
      },
      additional_vim_regex_highlighting = false,
      highlight = {
        enable = false,
        -- ファイルサイズが大きい場合はシンタックスハイライトをオフ
        disable = function(_, buf)
          return vim.b[buf].large_file == true
        end,
      },
      textsubjects = {
        enable = true,
        prev_selection = ',',
        keymaps = {
          ['.'] = 'textsubjects-smart',
          [';'] = 'textsubjects-container-outer',
          ['i;'] = 'textsubjects-container-inner',
        },
      },
    },
    init = function()
      -- nvim-treesitter master ブランチ(archived)互換パッチ:
      -- 0.13+ では query directive/predicate の match[capture_id] が TSNode から TSNode[] に変わったが、
      -- master ブランチの query_predicates は単一 TSNode 前提のため markdown injection 等で
      -- `attempt to call method 'range' (a nil value)` エラーになる。
      -- get_node_text に渡された table を最後の要素に正規化することで吸収する。
      do
        local orig = vim.treesitter.get_node_text
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.treesitter.get_node_text = function(node, source, opts)
          if type(node) == 'table' and node[1] then
            node = node[#node]
          end
          return orig(node, source, opts)
        end
      end

      vim.uv.new_timer():start(300, 0, vim.schedule_wrap(function()
        vim.cmd 'TSEnable highlight'
        require 'improve-default-scheme'.improve()
      end))
    end,
    dependencies = {
      { -- treesitterベースのテキストオブジェクト拡張
        'RRethy/nvim-treesitter-textsubjects',
      },
    },
  },
}
