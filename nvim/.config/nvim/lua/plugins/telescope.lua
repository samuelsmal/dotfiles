return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<Leader>o", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<Leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<Leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
}
