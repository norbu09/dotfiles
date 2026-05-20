vim.lsp.config("expert", {
  cmd = { "expert", "--stdio" },
  root_markers = { "mix.exs", ".git" },
  filetypes = { "elixir", "eelixir", "heex" },
})

vim.lsp.enable("expert")

return {}
-- "emmanueltouzery/elixir-extras.nvim",
-- lazy = true,
-- ft = "elixir",
-- dependencies = {
--   "nvim-telescope/telescope.nvim",
-- },
-- keys = {
--   {
--     "<leader>ed",
--     function()
--       require("elixir-extras").elixir_view_docs({})
--     end,
--     desc = "Elixir View Docs",
--   },
--   {
--     "<leader>em",
--     function()
--       require("elixir-extras").elixir_view_docs({ include_mix_libs = true })
--     end,
--     desc = "Elixir View Docs (mix libs)",
--   },
--   {
--     "<leader>ec",
--     function()
--       require("elixir-extras").module_complete()
--     end,
--     desc = "Elixir Module Complete",
--   },
-- },
-- config = function()
--   require("elixir-extras").setup_multiple_clause_gutter()
-- end,
