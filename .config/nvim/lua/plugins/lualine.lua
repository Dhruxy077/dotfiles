return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			opts = function(_, opts)
				-- Ensure the options table exists
				opts.options = opts.options or {}

				-- This tells Lualine to pull colors from the active Neovim colorscheme
				opts.options.theme = "auto"

				-- (Keep the rest of your custom lualine sections here)
			end,
		})
	end,
}
