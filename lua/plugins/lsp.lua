return {
  -- Mason: LSP/DAP/linter/formatter installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP servers
        "basedpyright",
        "gopls",
        "lua-language-server",
        -- Formatters
        "stylua",
        "gofumpt",
        "goimports",
        "black",
        "isort",
        -- Linters
        "ruff",
        "golangci-lint",
      },
      ui = {
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- LSP core (nvim 0.11 API — no lspconfig framework)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      -- Diagnostics
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        float = { border = "rounded", source = true },
      })

      -- Global capabilities (blink.cmp extends these)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      end)

      -- Global config applied to all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- On attach: keymaps + inlay hints
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if not client then return end

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          map("gd",         "<cmd>FzfLua lsp_definitions<cr>",      "Go to definition")
          map("gD",         vim.lsp.buf.declaration,                 "Go to declaration")
          map("gr",         "<cmd>FzfLua lsp_references<cr>",        "Go to references")
          map("gi",         "<cmd>FzfLua lsp_implementations<cr>",   "Go to implementation")
          map("gy",         "<cmd>FzfLua lsp_typedefs<cr>",          "Go to type definition")
          map("K",          vim.lsp.buf.hover,                       "Hover docs")
          map("<C-k>",      vim.lsp.buf.signature_help,              "Signature help")
          map("<leader>rn", vim.lsp.buf.rename,                      "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action,                 "Code action")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("[d",         function() vim.diagnostic.jump({ count = -1, float = false, on_jump = function() vim.diagnostic.open_float() end }) end, "Prev diagnostic")
          map("]d",         function() vim.diagnostic.jump({ count =  1, float = false, on_jump = function() vim.diagnostic.open_float() end }) end, "Next diagnostic")
          map("<leader>cd", vim.diagnostic.open_float,               "Line diagnostics")

          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- Server configs
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
            gofumpt = true,
            semanticTokens = true,
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              compositeLiteralTypes  = true,
              constantValues         = true,
              functionTypeParameters = true,
              parameterNames         = true,
              rangeVariableTypes     = true,
            },
          },
        },
      })

      -- workaround: gopls doesn't advertise semanticTokensProvider capability
      -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "gopls" then return end
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
            completion = { callSnippet = "Replace" },
            hint = { enable = true },
            telemetry = { enable = false },
          },
        },
      })

      -- Enable only the servers we want
      vim.lsp.enable({ "basedpyright", "gopls", "lua_ls" })
    end,
  },
}
