return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "lua", "luadoc",
        "python",
        "go", "gomod", "gowork", "gosum",
        "rust",
        "dart",
        "bash",
        "json", "jsonc",
        "yaml", "toml",
        "markdown", "markdown_inline",
        "html", "css",
        "vim", "vimdoc", "query",
        "regex",
        "diff",
        "git_config", "git_rebase", "gitcommit", "gitignore",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection   = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "outer function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ac"] = { query = "@class.outer",    desc = "outer class" },
            ["ic"] = { query = "@class.inner",    desc = "inner class" },
            ["aa"] = { query = "@parameter.outer",desc = "outer argument" },
            ["ia"] = { query = "@parameter.inner",desc = "inner argument" },
            ["ab"] = { query = "@block.outer",    desc = "outer block" },
            ["ib"] = { query = "@block.inner",    desc = "inner block" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer",    desc = "Next class start" },
            ["]a"] = { query = "@parameter.inner",desc = "Next argument start" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer",    desc = "Next class end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Prev function start" },
            ["[c"] = { query = "@class.outer",    desc = "Prev class start" },
            ["[a"] = { query = "@parameter.inner",desc = "Prev argument start" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Prev function end" },
            ["[C"] = { query = "@class.outer",    desc = "Prev class end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sa"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<leader>sA"] = { query = "@parameter.inner", desc = "Swap prev argument" },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
}
