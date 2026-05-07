return {
  -- AI chat + inline assist (Claude via Anthropic API)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<leader>ac",  "<cmd>CodeCompanionChat Toggle<cr>",    mode = { "n", "v" }, desc = "AI chat toggle" },
      { "<leader>aa",  "<cmd>CodeCompanionActions<cr>",        mode = { "n", "v" }, desc = "AI actions" },
      { "<leader>ai",  "<cmd>CodeCompanion<cr>",               mode = { "n", "v" }, desc = "AI inline" },
      { "<leader>an",  "<cmd>CodeCompanionChat<cr>",           mode = { "n", "v" }, desc = "AI new chat" },
      { "ga",          "<cmd>CodeCompanionChat Add<cr>",       mode = "v",          desc = "Add to AI chat" },
    },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = { api_key = "ANTHROPIC_API_KEY" },
            schema = {
              model = {
                default = "claude-sonnet-4-6",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
          keymaps = {
            send = { modes = { n = "<CR>", i = "<C-s>" } },
            close = { modes = { n = "q" } },
            stop = { modes = { n = "<C-c>" } },
          },
          slash_commands = {
            ["file"]   = { opts = { provider = "fzf_lua" } },
            ["buffer"] = { opts = { provider = "fzf_lua" } },
            ["help"]   = { opts = { provider = "fzf_lua" } },
          },
        },
        inline = {
          adapter = "anthropic",
          keymaps = {
            accept_change = { modes = { n = "ga" } },
            reject_change = { modes = { n = "gr" } },
          },
        },
        agent = {
          adapter = "anthropic",
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.35,
            border = "rounded",
          },
          show_token_count = true,
          show_settings = false,
        },
        inline = {
          layout = "vertical",
          diff = {
            enabled = true,
            close_chat_at = 240,
            layout = "vertical",
            opts = { "internal", "filler", "closeoff", "algorithm:patience" },
          },
        },
        action_palette = {
          provider = "default",
        },
      },
      opts = {
        log_level = "ERROR",
        send_code = true,
        silence_notifications = false,
        language = "English",
      },
    },
  },

  -- ThePrimeagen/99: bridges nvim to Claude Code CLI
  {
    "ThePrimeagen/99",
    event = "VeryLazy",
    config = function()
      local ok, _99 = pcall(require, "99")
      if not ok then return end

      _99.setup({
        provider = _99.Providers.ClaudeCodeProvider,
        tmp_dir = vim.fn.stdpath("cache") .. "/99",
        completion = { source = "blink" },
      })

      -- Search project with AI prompt -> quickfix
      vim.keymap.set("n", "<leader>9s", function() _99.search() end,  { desc = "99: AI search project" })
      -- Replace visual selection with AI output
      vim.keymap.set("v", "<leader>9v", function() _99.visual() end,  { desc = "99: AI visual replace" })
      -- Cancel active request
      vim.keymap.set("n", "<leader>9x", function() _99.cancel() end,  { desc = "99: Cancel request" })
      -- Work tracker
      vim.keymap.set("n", "<leader>9w", function() _99.work() end,    { desc = "99: Work tracker" })
    end,
  },
}
