return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized").setup()
      vim.cmd.colorscheme("solarized")
    end,
  },
}
