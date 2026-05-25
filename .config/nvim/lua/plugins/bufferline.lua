return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = "VeryLazy",
	keys = {
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
	},
	opts = {
		options = {
			mode = "buffers", -- Show open files, not vim tabs
			separator_style = "slant", -- Options: "slant", "thick", "thin"
			show_buffer_close_icons = true,
			show_close_icon = false,
			diagnostics = "nvim_lsp", -- Show lsp error icons on tabs
			offsets = {
				{
					filetype = "neo-tree",
					text = "File Explorer",
					text_align = "left",
					separator = true,
				},
			},
		},
	},
}
