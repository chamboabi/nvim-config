return {
  -- File explorer
  {
    "A7Lavinraj/fyler.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "-", function() require("fyler").open({ kind = "floating" }) end, desc = "Open parent dir" },
    },
    opts = {
      integrations = {
        icon = "nvim_web_devicons",
      },
      use_as_default_explorer = true,
      auto_confirm_simple_mutation = true,
      kind = "replace",
      kind_presets = {
        floating = {
          border = "rounded",
          height = "80%",
          width = "60%",
          col = "center",
          row = "center",
        },
      },
      mappings = {
        n = {
          ["q"]     = { action = "close" },
          ["<CR>"]  = { action = "select", args = { close = true } },
          ["<C-v>"] = { action = "select", args = { vsplit = true } },
          ["<C-s>"] = { action = "select", args = { split = true } },
          ["<C-t>"] = { action = "select", args = { tabedit = true } },
          ["<C-c>"] = { action = "close" },
          ["-"]     = { action = "visit", args = { parent = true } },
          ["."]     = { action = "visit", args = { cursor = true } },
          ["<BS>"]  = { action = "shrink", args = { parent = true } },
        },
      },
      win_opts = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
    },
  },

  -- Undo history
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history" },
    },
    config = function()
      local telescope_undo = require("telescope-undo.actions")
      require("telescope").setup({
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.6 },
            mappings = {
              i = {
                ["<C-cr>"] = telescope_undo.restore,
                ["<C-y>"]  = telescope_undo.yank_additions,
                ["<C-Y>"]  = telescope_undo.yank_deletions,
              },
            },
          },
        },
      })
      require("telescope").load_extension("undo")
    end,
  },
}
