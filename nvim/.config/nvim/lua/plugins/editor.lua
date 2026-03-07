return {
  -- Git integration
  { "tpope/vim-fugitive" },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Alignment
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy align" },
    },
  },

  -- f/t motion highlighting
  { "unblevable/quick-scope" },

  -- Tabular alignment
  { "godlygeek/tabular", cmd = "Tabularize" },

  -- YAML folding via treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "yaml", "json", "bash", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
