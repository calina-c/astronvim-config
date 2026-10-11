return {
  {
    "coder/claudecode.nvim",

    dependencies = {
      "folke/snacks.nvim",
    },

    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",

      "ClaudeProfile",
      "ClaudeProfileStatus",
    },

    config = function()
      require("claudecode").setup()

      local profiles = {
        Personal = vim.fn.expand "~/.claude-profiles/Personal",
        Cobaltix = vim.fn.expand "~/.claude-profiles/Cobaltix",
      }

      local function switch_profile(name)
        local directory = profiles[name]

        if not directory then
          vim.notify("Unknown Claude profile: " .. tostring(name), vim.log.levels.ERROR)
          return
        end

        if vim.fn.isdirectory(directory) ~= 1 then
          vim.notify("Claude profile directory not found: " .. directory, vim.log.levels.ERROR)
          return
        end

        pcall(vim.cmd, "ClaudeCodeClose")
        pcall(vim.cmd, "ClaudeCodeStop")

        vim.env.CLAUDE_CONFIG_DIR = directory
        vim.g.claude_profile = name

        vim.schedule(function()
          vim.cmd "ClaudeCodeStart"
          vim.cmd "ClaudeCode"

          vim.notify("Claude profile: " .. name, vim.log.levels.INFO)
        end)
      end

      vim.api.nvim_create_user_command("ClaudeProfile", function(command)
        if command.args ~= "" then
          switch_profile(command.args)
          return
        end

        vim.ui.select({ "Personal", "Cobaltix" }, { prompt = "Select Claude profile" }, function(choice)
          if choice then switch_profile(choice) end
        end)
      end, {
        nargs = "?",
        complete = function() return { "Personal", "Cobaltix" } end,
        desc = "Switch Claude Code profile",
      })

      vim.api.nvim_create_user_command(
        "ClaudeProfileStatus",
        function()
          vim.notify(
            string.format(
              "Profile: %s\nCLAUDE_CONFIG_DIR: %s",
              vim.g.claude_profile or "Personal",
              vim.env.CLAUDE_CONFIG_DIR or profiles.Personal
            )
          )
        end,
        {
          desc = "Show active Claude profile",
        }
      )

      if not vim.env.CLAUDE_CONFIG_DIR then
        vim.env.CLAUDE_CONFIG_DIR = profiles.Personal
        vim.g.claude_profile = "Personal"
      end
    end,

    keys = {
      {
        "<leader>ac",
        "<cmd>ClaudeCode<cr>",
        desc = "Toggle Claude",
      },
      {
        "<leader>ax",
        "<cmd>ClaudeProfile<cr>",
        desc = "Switch Claude profile",
      },
      {
        "<leader>aw",
        "<cmd>ClaudeProfile Cobaltix<cr>",
        desc = "Claude profile: Cobaltix",
      },
      {
        "<leader>ap",
        "<cmd>ClaudeProfile Personal<cr>",
        desc = "Claude profile: Personal",
      },
    },
  },
}
