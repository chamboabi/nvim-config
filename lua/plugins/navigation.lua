return {
  -- File explorer
  {
    "A7Lavinraj/fyler.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "-",         function() require("fyler").open({ kind = "float" }) end, desc = "Open parent dir" },
      { "<leader>-", function() require("fyler").open({ kind = "float" }) end, desc = "Fyler float" },
      { "<leader>e", function() require("fyler").open({ kind = "float" }) end, desc = "File explorer" },
    },
    opts = {
      integrations = {
        icon = "nvim_web_devicons",
      },
      views = {
        finder = {
          default_explorer = true,
          delete_to_trash = true,
          confirm_simple = false,
          mappings = {
            ["q"]     = "CloseView",
            ["<CR>"]  = "Select",
            ["<C-v>"] = "SelectVSplit",
            ["<C-s>"] = "SelectSplit",
            ["<C-t>"] = "SelectTab",
            ["<C-c>"] = "CloseView",
            ["-"]     = "GotoParent",
            ["_"]     = "GotoCwd",
            ["."]     = "GotoNode",
            ["#"]     = "CollapseAll",
            ["<BS>"]  = "CollapseNode",
          },
          win = {
            border = "rounded",
            kind = "float",
            kinds = {
              float = {
                height = "80%",
                width = "60%",
                top = "10%",
                left = "20%",
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
