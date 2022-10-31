" Change source options
call ddc#custom#patch_global('ui', 'native')
call ddc#custom#patch_global('sources', ['around', 'nvim-lsp', 'deoppet'])
call ddc#custom#patch_global('sourceOptions', {
      \ '_': { 'matchers': ['matcher_head'], 'ignoreCase': v:true },
      \ 'deoppet': {'dup': v:true, 'mark': 'dp'},
      \ 'nvim-lsp': {
      \   'mark': 'L',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ })

" Use Customized labels
call ddc#custom#patch_global('sourceParams', {
      \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
      \ })

" <TAB>: completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? '<C-n>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB> pumvisible() ? '<C-p>' : '<C-h>'

call ddc#enable()
