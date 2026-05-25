return {
	-- Bash/Shell scripting support
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {
					filetypes = { "sh", "bash", "zsh" },
				},
			},
		},
	},

	-- Treesitter for Linux/Shell
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"bash",
				"fish",
				"make",
				"cmake",
				"ninja",
				"toml",
				"yaml",
				"ini",
			})
			-- Enable treesitter-based indentation
			opts.indent = opts.indent or {}
			opts.indent.enable = true
		end,
	},

	-- Mason tools for Linux development
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"bash-language-server",
				"shellcheck",
				"shfmt",
				"yamllint",
				"yamlfmt",
				"actionlint",
			})
		end,
	},

	-- Better terminal integration
	-- Better terminal integration
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 20,
			open_mapping = [[<C-/>]], -- Changed from <c-`> to your preferred mapping
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell, -- This will automatically pick up your Fish shell
			float_opts = {
				border = "curved",
				winblend = 3,
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			-- Your custom terminal navigation keymaps
			function _G.set_terminal_keymaps()
				local buffer_opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], buffer_opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], buffer_opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], buffer_opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], buffer_opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], buffer_opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], buffer_opts)
				vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], buffer_opts)
			end

			vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
		end,
	},
}
