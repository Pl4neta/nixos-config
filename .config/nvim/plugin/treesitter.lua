require'nvim-treesitter.configs'.setup {
  --ensure_installed = { "help", "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query" },
  ensure_installed = { "javascript", "typescript", "c", "lua", "vim", "vimdoc", "query" },

  sync_install = false,
 
  auto_install = true,

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}
