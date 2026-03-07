return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<Leader>n", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
    },
    opts = {
      close_if_last_window = true,
      window = {
        width = 30,
      },
    },
  },
}
