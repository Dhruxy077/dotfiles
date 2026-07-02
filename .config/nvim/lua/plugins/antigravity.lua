return {
	"NakLast/antigravity-cli.nvim",
	config = function()
		require("antigravity").setup({
			cmd = vim.fn.expand("$HOME/.local/bin/agy"), -- Default command to spawn the agent
			width_ratio = 0.8,
			height_ratio = 0.8,
			border = "rounded",
		})
		vim.keymap.set("n", "<leader>ag", "<cmd>Antigravity<cr>", { desc = "Opens Antigravity" })
	end,
}
