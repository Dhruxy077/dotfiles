-- Colorschemes Plugin Configuration
-- A collection of themes to switch between.

return {
	{
		"philosofonusus/morta.nvim",
		name = "morta",
		lazy = true,
		priority = 1000,
		opts = {
			styles = {
				transparency = true,
				italic = true,
				bold = false,
			},
		},
	},

	{
		"sainnhe/gruvbox-material",
		lazy = true,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_enable_bold = true
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				sidebars = "dark",
				floats = "dark",
			},
			on_colors = function(colors)
				colors.bg = "#1a1b26"
				colors.bg_dark = "#16161e"
				colors.bg_float = "#16161e"
				colors.bg_sidebar = "#1d1f2d"
				colors.bg_statusline = "#1d1f2d"
				colors.bg_popup = "#1d1f2d"
			end,
		},
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			transparent = true,
			terminal_colors = true,
		},
	}, -- lazy
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			styles = {
				comments = { "italic" },
				keywords = { "italic" },
			},
		},
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				transparent = true,
				dimInactive = false,
				terminalColors = true,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
						PmenuSel = { bg = theme.ui.bg_p2 },
						Comment = { italic = true },
					}
				end,
			})
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		priority = 1000,
		opts = {
			styles = {
				transparency = true,
				italic = true,
			},
		},
	},

	{
		"navarasu/onedark.nvim",
		name = "onedark",
		lazy = true,
		priority = 1000,
		opts = {
			style = "cool",
			transparent = false,
		},
	},

	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			transparent = false,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
			},
			dim_inactive = true,
		},
	},

	{
		"tiagovla/tokyodark.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			transparent_background = false,
		},
	},

	{
		"danfry1/lume",
		lazy = true,
		priority = 1000,
		config = function()
			require("lume").setup()
		end,
	},

	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = true,
		priority = 1000,
		-- NOTE: No config block here — do NOT call vim.cmd.colorscheme() inside a
		-- lazy=true plugin config, it would override your chosen theme on every load.
		-- Transparency overrides are applied via the ColorScheme autocmd in autocmds.lua.
	},
	{
		"neanias/everforest-nvim",
		lazy = true,
		priority = 1000,
	},
	-- ==========================================
	-- 🎨 SET THE DEFAULT THEME HERE
	-- ==========================================
	{
		"LazyVim/LazyVim",
		opts = {
			-- Change to "kanagawa", "tokyonight", "rose-pine", "oxocarbon", etc.
			colorscheme = "catppuccin",
		},
	},
}
