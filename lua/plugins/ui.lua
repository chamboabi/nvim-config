return {
  -- Buffer tabline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
    keys = {
      { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",       desc = "Prev buffer" },
      { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",       desc = "Next buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",       desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",     desc = "Close other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>",      desc = "Close buffers to right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",       desc = "Close buffers to left" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",       desc = "Prev buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",       desc = "Next buffer" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",        desc = "Move buffer left" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",        desc = "Move buffer right" },
    },
    opts = {
      options = {
        close_command       = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command  = "buffer %d",
        middle_mouse_command = nil,
        indicator = { style = "icon", icon = "▎" },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " ", hint = " ", info = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
            .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "oil",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = "slant",
        always_show_bufferline = false,
        hover = { enabled = true, delay = 200, reveal = { "close" } },
      },
    },
  },

  -- Icons
  {
    "echasnovski/mini.icons",
    version = "*",
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = c.orange, bold = true }
        hl.LineNr = { fg = c.dark5 }
        hl.FoldColumn = { fg = c.dark5, bg = c.none }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Statusline
  {
    "echasnovski/mini.statusline",
    version = "*",
    lazy = false,
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git           = statusline.section_git({ trunc_width = 75 })
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
            local location      = statusline.section_location({ trunc_width = 75 })
            local search        = statusline.section_searchcount({ trunc_width = 75 })

            return statusline.combine_groups({
              { hl = mode_hl,                 strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            })
          end,
        },
      })
    end,
  },

  -- Snacks (lazygit, notifications, pickers, etc)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = false }, -- using fzf-lua instead
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,        desc = "Lazygit current file" },
      { "<leader>gl", function() Snacks.lazygit.log() end,             desc = "Lazygit log" },
      { "<leader>un", function() Snacks.notifier.show_history() end,   desc = "Notification history" },
      { "<leader>nd", function() Snacks.notifier.hide() end,           desc = "Dismiss notifications" },
      { "<leader>.",  function() Snacks.scratch() end,                 desc = "Scratch buffer" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next word reference" },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev word reference" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Global helpers
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd
        end,
      })
    end,
  },
}
