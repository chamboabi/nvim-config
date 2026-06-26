return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				"                                                                                  ",
				"   ██████╗ ██╗  ██╗ █████╗ ███╗   ███╗██████╗  ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"  ██╔════╝ ██║  ██║██╔══██╗████╗ ████║██╔══██╗██╔═══██╗██║   ██║██║████╗ ████║",
				"  ██║      ███████║███████║██╔████╔██║██████╔╝██║   ██║██║   ██║██║██╔████╔██║",
				"  ██║      ██╔══██║██╔══██║██║╚██╔╝██║██╔══██╗██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"  ╚██████╗ ██║  ██║██║  ██║██║ ╚═╝ ██║██████╔╝╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
				"                                                                                  ",
			}

			dashboard.section.buttons.val = {
				dashboard.button("n", " 󰈔  New file",        "<cmd>ene <BAR> startinsert<cr>"),
				dashboard.button("f", " 󰍉  Find file",       "<cmd>FzfLua files<cr>"),
				dashboard.button("r", "   Recent files",    "<cmd>FzfLua oldfiles<cr>"),
				dashboard.button("g", " 󰊄  Live grep",       "<cmd>FzfLua live_grep<cr>"),
				dashboard.button("l", " 󰒲  Lazy",            "<cmd>Lazy<cr>"),
				dashboard.button("q", " 󰅚  Quit",            "<cmd>qa<cr>"),
			}

			dashboard.section.footer.val = function()
				local stats = require("lazy").stats()
				return " 󰏓  " .. stats.loaded .. "/" .. stats.count .. " plugins loaded"
			end

			dashboard.section.footer.opts.hl = "Comment"
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"

			alpha.setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					dashboard.section.footer.val = " 󰏓  " .. stats.loaded .. "/" .. stats.count .. " plugins loaded"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
