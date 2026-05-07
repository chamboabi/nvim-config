return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      -- Files
      { "<leader><leader>", "<cmd>FzfLua files<cr>",                desc = "Find files" },
      { "<leader>fr",       "<cmd>FzfLua oldfiles<cr>",             desc = "Recent files" },
      { "<leader>fc",       "<cmd>FzfLua files cwd=~/.config/nvim<cr>", desc = "Find config files" },

      -- Grep
      { "<leader>/",        "<cmd>FzfLua live_grep<cr>",            desc = "Live grep" },
      { "<leader>fw",       "<cmd>FzfLua grep_cword<cr>",           desc = "Grep word under cursor" },
      { "<leader>fW",       "<cmd>FzfLua grep_cWORD<cr>",           desc = "Grep WORD under cursor" },
      { "<leader>fs",       "<cmd>FzfLua grep_visual<cr>",          mode = "v", desc = "Grep selection" },

      -- Buffers
      { "<leader>fb",       "<cmd>FzfLua buffers<cr>",              desc = "Find buffers" },

      -- LSP
      { "<leader>ls",       "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>lS",       "<cmd>FzfLua lsp_workspace_symbols<cr>",desc = "Workspace symbols" },
      { "<leader>lr",       "<cmd>FzfLua lsp_references<cr>",       desc = "LSP references" },
      { "<leader>ld",       "<cmd>FzfLua lsp_definitions<cr>",      desc = "LSP definitions" },
      { "<leader>li",       "<cmd>FzfLua lsp_implementations<cr>",  desc = "LSP implementations" },

      -- Misc
      { "<leader>fh",       "<cmd>FzfLua help_tags<cr>",            desc = "Help tags" },
      { "<leader>fk",       "<cmd>FzfLua keymaps<cr>",              desc = "Keymaps" },
      { "<leader>fC",       "<cmd>FzfLua commands<cr>",             desc = "Commands" },
      { "<leader>fd",       "<cmd>FzfLua diagnostics_document<cr>", desc = "Document diagnostics" },
      { "<leader>fD",       "<cmd>FzfLua diagnostics_workspace<cr>",desc = "Workspace diagnostics" },
      { "<leader>fg",       "<cmd>FzfLua git_commits<cr>",          desc = "Git commits" },
      { "<leader>fB",       "<cmd>FzfLua git_bcommits<cr>",         desc = "Git buffer commits" },
      { "<leader>fR",       "<cmd>FzfLua resume<cr>",               desc = "Resume last picker" },
    },
    opts = {
      "telescope",  -- use telescope-style defaults
      winopts = {
        height = 0.85,
        width = 0.85,
        row = 0.35,
        col = 0.50,
        preview = {
          layout = "flex",
          flip_columns = 120,
          scrollbar = false,
        },
      },
      fzf_opts = {
        ["--ansi"] = true,
        ["--info"] = "inline",
        ["--height"] = "100%",
        ["--layout"] = "reverse",
        ["--border"] = "none",
      },
      files = {
        formatter = "path.filename_first",
        hidden = true,
        follow = true,
        git_icons = true,
        file_icons = true,
      },
      grep = {
        hidden = true,
        follow = true,
        formatter = "path.filename_first",
      },
      lsp = {
        symbols = {
          symbol_icons = {
            File = "󰈙",
            Module = "",
            Namespace = "󰦮",
            Package = "",
            Class = "󰆧",
            Method = "󰊕",
            Property = "",
            Field = "",
            Constructor = "",
            Enum = "",
            Interface = "",
            Function = "󰊕",
            Variable = "󰀫",
            Constant = "󰏿",
            String = "󰉿",
            Number = "󰎠",
            Boolean = "◩",
            Array = "󰅪",
            Object = "󰅩",
            Key = "󰌋",
            Null = "󰟢",
            EnumMember = "",
            Struct = "󰆼",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰬛",
          },
        },
      },
    },
  },
}
