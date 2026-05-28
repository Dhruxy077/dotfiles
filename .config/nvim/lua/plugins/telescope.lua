return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim", -- ✅ moved here as dependency
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local utils = require("telescope.utils")

			-- ✅ Single unified setup call
			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = { prompt_position = "top" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- ✅ Load extensions after setup
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")

			-- Keymaps
			-- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({ cwd = utils.buffer_dir() })
			end, { desc = "Find Files (Current Dir)" })
			vim.keymap.set("n", "<leader>ff", builtin.live_grep, { desc = "Live Grep" }) -- ✅ use builtin, not :Telescope cmd
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
		end,
	},
}
