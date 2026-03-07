-- Highlight status bar in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.api.nvim_set_hl(0, "StatusLine", { ctermfg = 235, ctermbg = 2 })
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = 240, ctermfg = 12 })
  end,
})

-- Regenerate spell files if necessary
for _, d in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/spell/*.add", true, true)) do
  if vim.fn.filereadable(d) == 1
    and (vim.fn.filereadable(d .. ".spl") == 0 or vim.fn.getftime(d) > vim.fn.getftime(d .. ".spl"))
  then
    vim.cmd("mkspell! " .. vim.fn.fnameescape(d))
  end
end
