return {
	"stevearc/conform.nvim",
	dependencies = { "mason-org/mason.nvim" }, -- Ensure Mason is loaded
	lazy = false,
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = true,
					-- Note: "injected" is great for code blocks inside markdown
					formatters = { "injected" },
					timeout_ms = 1000,
				})
			end,
			mode = { "n" },
			desc = "Format Injected Langs",
		},
		-- Adding a standard format keybind is usually helpful too
		{
			"<leader>df",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	-- config = function()
	-- 	require("conform").setup({
	-- 		formatters_by_ft = {
	-- 			lua = { "stylua" },
	-- 			python = { "isort", "black" },
	-- 			rust = { "rustfmt", lsp_format = "fallback" },
	-- 			-- Matches your web dev interests
	-- 			javascript = { "prettierd", "prettier", stop_after_first = true },
	-- 			typescript = { "prettierd", "prettier", stop_after_first = true },
	-- 			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
	-- 			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
	-- 			-- Corrected names
	-- 			cpp = { "clang-format" },
	-- 			c = { "clang-format" },
	-- 			css = { "prettierd", "prettier", stop_after_first = true },
	-- 			html = { "prettierd", "prettier", stop_after_first = true },
	-- 		},
	-- 	})
	-- end,
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			cpp = { "clang-format" },
			c = { "clang-format" },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
		},
	},
}
