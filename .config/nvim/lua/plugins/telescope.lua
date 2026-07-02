return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		-- Keys defined HERE are registered at startup immediately.
		-- They also act as lazy-load triggers for telescope itself.
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
			{ "<leader>fw", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
			{ "<leader>fc", "<cmd>Telescope find_files cwd=%:p:h<cr>",      desc = "Find Files (Current Dir)" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help Tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent Files" },
		},
		config = function()
			local telescope = require("telescope")
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

			-- Override <leader>fc to use buffer_dir() properly (can't do this in keys table)
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({ cwd = utils.buffer_dir() })
			end, { desc = "Find Files (Current Dir)" })
		end,
	},
}
