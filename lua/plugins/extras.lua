return {
  -- Diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Workspace diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions/refs" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix list" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Prev trouble/quickfix",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Next trouble/quickfix",
      },
    },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
  },

  -- Folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,           desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end,          desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end,   desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end,         desc = "Close folds with" },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then vim.lsp.buf.hover() end
        end,
        desc = "Peek fold or hover",
      },
    },
    opts = {
      provider_selector = function(_, filetype, _)
        local ft_map = {
          dart   = { "lsp", "indent" },
          python = { "lsp", "indent" },
          go     = { "lsp", "indent" },
          rust   = { "lsp", "indent" },
          lua    = { "treesitter", "indent" },
        }
        return ft_map[filetype] or { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      icons = {
        mappings = true,
        keys = {
          Up    = " ", Down  = " ", Left  = " ", Right = " ",
          C     = "󰘴 ", M     = "󰘵 ", S     = "󰘶 ", CR    = "󰌑 ",
          Esc   = "󱊷 ", Tab   = "󰌒 ", Space = "󱁐 ",
        },
      },
      spec = {
        { "<leader>9",  group = "99/ai-cli" },
        { "<leader>a",  group = "ai/codecompanion" },
        { "<leader>b",  group = "buffers" },
        { "<leader>c",  group = "code" },
        { "<leader>e",  group = "explorer" },
        { "<leader>f",  group = "find" },
        { "<leader>F",  group = "flutter" },
        { "<leader>g",  group = "git" },
        { "<leader>l",  group = "lsp" },
        { "<leader>n",  group = "notifications" },
        { "<leader>q",  group = "quit/session" },
        { "<leader>r",  group = "rust" },
        { "<leader>s",  group = "swap" },
        { "<leader>u",  group = "ui" },
        { "<leader>w",  group = "windows" },
        { "<leader>x",  group = "diagnostics/trouble" },
        { "[",          group = "prev" },
        { "]",          group = "next" },
        { "g",          group = "goto" },
        { "z",          group = "fold" },
      },
    },
  },
}
