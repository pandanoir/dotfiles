-- tailwindが設定されたプロジェクトでのみ有効化する
return {
  root_dir = function(bufnr, callback)
    local found_dirs = vim.fs.find({
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
    }, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
    })
    if #found_dirs > 0 then
      return callback(vim.fs.dirname(found_dirs[1]))
    end

    -- viteプロジェクトの場合tailwindの設定はvite.config.tsにしか書いてないので、vite.config.tsをチェックする
    found_dirs = vim.fs.find({ 'vite.config.ts' }, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
    })
    if #found_dirs == 0 then
      return
    end

    local file = io.open(found_dirs[1], "r")
    if not file then
      return
    end
    local content = file:read("*a")
    file:close()

    if content:find("@tailwindcss/vite") then
      return callback(vim.fs.dirname(found_dirs[1]))
    end
  end,
}
