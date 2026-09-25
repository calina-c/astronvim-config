return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = {
      nls.builtins.diagnostics.pylint.with({
        extra_args = { "--disable=C0114,C0115,C0116" }, -- example: disable docstring warnings
      }),
    }
  end,
}
