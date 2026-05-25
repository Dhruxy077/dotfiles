return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- This starts tracking your session as soon as you open a file
	opts = {

		-- This explicitly sets the directory for sessions
		dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
		options = { "buffers", "curdir", "tabpages", "winsize" },
	},
}
