return {
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = { auto_focus = true },
          float_win_config = { border = "rounded" },
        },
        server = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Rust: " .. desc })
            end

            map("<leader>re", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
            map("<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Runnables")
            map("<leader>rt", function() vim.cmd.RustLsp("testables") end, "Testables")
            map("<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
            map("<leader>rm", function() vim.cmd.RustLsp("rebuildProcMacros") end, "Rebuild proc macros")
            map("<leader>ro", function() vim.cmd.RustLsp("openDocs") end, "Open docs.rs")
            map("<leader>rp", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
            map("<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
            map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover actions")
            map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code action")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              checkOnSave = true,
              check = { command = "clippy", extraArgs = { "--no-deps" } },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"]     = { "async_trait" },
                  ["napi-derive"]     = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              inlayHints = {
                bindingModeHints       = { enable = false },
                chainingHints          = { enable = true },
                closingBraceHints      = { enable = true, minLines = 25 },
                closureReturnTypeHints = { enable = "never" },
                lifetimeElisionHints   = { enable = "never" },
                parameterHints         = { enable = true },
                typeHints              = { enable = true },
              },
            },
          },
        },
      }
    end,
  },

  -- Dart / Flutter
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    keys = {
      { "<leader>Fs", "<cmd>FlutterRun<cr>",           desc = "Flutter run" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>",          desc = "Flutter quit" },
      { "<leader>Fr", "<cmd>FlutterHotReload<cr>",     desc = "Flutter hot reload" },
      { "<leader>FR", "<cmd>FlutterHotRestart<cr>",    desc = "Flutter hot restart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>",       desc = "Flutter devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>",     desc = "Flutter emulators" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter outline" },
      { "<leader>FD", "<cmd>FlutterDevTools<cr>",      desc = "Flutter DevTools" },
      { "<leader>Fl", "<cmd>FlutterLogClear<cr>",      desc = "Flutter log clear" },
      { "<leader>Fp", "<cmd>FlutterPubGet<cr>",        desc = "Flutter pub get" },
    },
    opts = {
      ui = {
        border = "rounded",
        notification_style = "native",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = false,
        },
      },
      flutter_path = nil,       -- auto-detected
      flutter_lookup_cmd = nil, -- auto-detected
      root_patterns = { ".git", "pubspec.yaml" },
      fvm = true,
      widget_guides = { enabled = true },
      closing_tags = {
        highlight = "ErrorMsg",
        prefix = "//",
        priority = 10,
        enabled = true,
      },
      dev_log = {
        enabled = true,
        filter = nil,
        notify_errors = true,
        open_cmd = "tabedit",
      },
      lsp = {
        on_attach = function(_, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Flutter: " .. desc })
          end
          map("<leader>Fw", "<cmd>FlutterOutlineToggle<cr>", "Widget outline")
        end,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            vim.fn.expand("$HOME/.pub-cache"),
            vim.fn.expand("$HOME/fvm/versions"),
            vim.fn.expand("$HOME/.fvm"),
          },
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
    },
  },
}
