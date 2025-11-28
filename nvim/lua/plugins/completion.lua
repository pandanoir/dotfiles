return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip', dependencies = { 'rafamadriz/friendly-snippets' } },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    opts = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.filetype_extend('typescript', { 'javascript' })
      luasnip.filetype_extend('typescriptreact', { 'javascript' })
      require 'luasnip.loaders.from_vscode'.lazy_load()

      return {
        enabled = true,
        mapping = cmp.mapping.preset.insert {
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<M-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources {
          { name = 'skkeleton' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
        },
        experimental = {
          ghost_text = true
        },
      }
    end,
  },
  {
    'rinx/cmp-skkeleton',
    dependencies = { 'hrsh7th/nvim-cmp', 'vim-skk/skkeleton' },
    event = 'InsertEnter',
  },
  {
    'vim-skk/skkeleton',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      vim.fn['skkeleton#config']({
        globalDictionaries = { os.getenv("XDG_DATA_HOME") .. '/skk/SKK-JISYO.L' },
        eggLikeNewline = true,
        showCandidatesCount = 2,
      })
      vim.keymap.set('i', 'jj', '<Plug>(skkeleton-enable)')
      vim.keymap.set('c', 'jj', '<Plug>(skkeleton-enable)')

      vim.keymap.set('i', '<c-l>', '<Plug>(skkeleton-enable)')
      vim.keymap.set('c', '<c-l>', '<Plug>(skkeleton-enable)')

      vim.fn['skkeleton#register_kanatable']('rom', {
        ['fd'] = 'escape',
      })
    end,
  }
}
