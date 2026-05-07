return {
  -- nvim-cmp source compatibility layer for blink.cmp
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = { impersonate_nvim_cmp = true },
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })

      luasnip.config.setup({
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        region_check_events = "InsertEnter",
      })

      -- Jump through snippet nodes
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.jumpable(1) then luasnip.jump(1) end
      end, { desc = "Snippet jump forward" })
      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if luasnip.jumpable(-1) then luasnip.jump(-1) end
      end, { desc = "Snippet jump backward" })
      vim.keymap.set({ "i", "s" }, "<C-e>", function()
        if luasnip.choice_active() then luasnip.change_choice(1) end
      end, { desc = "Snippet cycle choice" })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "v0.*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]     = { "hide" },
        ["<C-y>"]     = { "select_and_accept" },
        ["<C-p>"]     = { "select_prev", "fallback" },
        ["<C-n>"]     = { "select_next", "fallback" },
        ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
        ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
        ["<Tab>"]     = { "snippet_forward", "fallback" },
        ["<S-Tab>"]   = { "snippet_backward", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
        kind_icons = {
          Text          = "󰉿",
          Method        = "󰊕",
          Function      = "󰊕",
          Constructor   = "󰒓",
          Field         = "󰜢",
          Variable      = "󰀫",
          Property      = "󰖷",
          Class         = "󱡠",
          Interface     = "󱡠",
          Struct        = "󱡠",
          Module        = "󰅩",
          Unit          = "󰪚",
          Value         = "󰦨",
          Enum          = "󰦨",
          EnumMember    = "󰦨",
          Keyword       = "󰻾",
          Constant      = "󰏿",
          Snippet       = "󱄽",
          Color         = "󰏘",
          File          = "󰈔",
          Reference     = "󰬲",
          Folder        = "󰉋",
          Event         = "󱐋",
          Operator      = "󰪚",
          TypeParameter = "󰬛",
          Copilot       = "",
        },
      },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
          },
        },
        ghost_text = { enabled = true },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            score_offset = 5,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            score_offset = -3,
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  return vim.bo[buf].buftype == ""
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },

      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
    },
  },
}
