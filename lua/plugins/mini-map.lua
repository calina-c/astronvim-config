return {
  "echasnovski/mini.map",
  version = false,
  config = function()
    local map = require("mini.map")
    map.setup({
      symbols = { encode = map.gen_encode_symbols.dot("4x2") },
      window = {
        side = "right",
        width = 20,
        winblend = 25,
        show_integration_count = false,
      },
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diagnostic(),
      },
    })

    -- Auto open on certain filetypes
    local auto_open_filetypes = {
      "lua", "python", "javascript", "typescript", "go", "rust", "c", "cpp", "java",
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = auto_open_filetypes,
      callback = function()
        map.open()
      end,
    })

    -- Optional: Toggle keymap
    vim.keymap.set("n", "<leader>mm", map.toggle, { desc = "Toggle MiniMap" })
  end,
  event = "VeryLazy",
}

