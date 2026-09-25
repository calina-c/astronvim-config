return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "ag",
        "--nocolor",
        "--nogroup",
        "--column",
        "--smart-case",
        "--hidden",
        "--ignore", ".git",
      },
    },
  },
  keys = {
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files", mode = "n" },
      { "<leader>f", "<cmd>Telescope live_grep<cr>", desc = "Live Grep", mode = "n" },
  },
}
