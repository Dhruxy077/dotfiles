return {
	-- 1. This plugin calculates the correct comment string based on your cursor location in the AST
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},

	-- 2. This applies the comment string to Neovim's native commenting system or mini.comment
	{
		"nvim-mini/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},
}
