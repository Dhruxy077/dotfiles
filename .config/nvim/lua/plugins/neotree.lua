return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("neo-tree").setup({
				----------------------------------------------------------------
				-- 🚫 Startup behavior
				----------------------------------------------------------------
				close_if_last_window = true,
				sort_case_insensitive = true,

				enable_git_status = true,
				enable_diagnostics = true,

				ui = {
					confirm = {
						delete = true,
						rename = true,
					},
				},

				popup_border_style = "rounded",

				----------------------------------------------------------------
				-- 🎨 Component styles
				----------------------------------------------------------------
				default_component_configs = {
					container = {
						enable_character_fade = false,
					},

					-- 🌿 Indentation
					indent = {
						indent_size = 2,
						padding = 0,
						with_markers = false,
						with_expanders = true,
						expander_collapsed = "›",
						expander_expanded = "⌄",
						expander_highlight = "NeoTreeExpander",
					},

					-- 📁 Clean Nerd Font icons
					icon = {
						folder_closed = "󰉋",
						folder_open = "󰝰",
						folder_empty = "󰉖",
						folder_empty_open = "󰉖",
						default = "󰈔",
						highlight = "NeoTreeFileIcon",
					},

					modified = {
						symbol = "●",
						highlight = "NeoTreeModified",
					},

					name = {
						trailing_slash = false,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
					},

					-- Minimal git symbols
					git_status = {
						symbols = {
							added = "+",
							modified = "~",
							deleted = "-",
							renamed = ">",
							untracked = "?",
							ignored = "",
							unstaged = "!",
							staged = "*",
							conflict = "C", -- ← changed from "!" to avoid duplicate with unstaged
						},
					},
				},

				----------------------------------------------------------------
				-- 🪟 Window
				----------------------------------------------------------------
				window = {
					position = "left",
					width = 34,
					mappings = {
						["<cr>"] = "open",
						["l"] = "open",
						["h"] = "close_node",
						["<esc>"] = "cancel",
						["P"] = { "toggle_preview", config = { use_float = true } },
						["s"] = "split_with_window_picker", -- ← uses nvim-window-picker
						["v"] = "vsplit_with_window_picker", -- ← uses nvim-window-picker
						["t"] = "open_tabnew",
						["a"] = "add",
						["A"] = "add_directory",
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["R"] = "refresh",
						["q"] = "close_window",
						["?"] = "show_help",
					},
				},

				----------------------------------------------------------------
				-- 📁 Filesystem
				----------------------------------------------------------------
				filesystem = {
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
					group_empty_dirs = true,
					hijack_netrw_behavior = "open_default",
					use_libuv_file_watcher = true,

					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = false,
					},

					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
						},
					},
				},

				----------------------------------------------------------------
				-- 📦 Buffers
				----------------------------------------------------------------
				buffers = {
					follow_current_file = { enabled = true },
					group_empty_dirs = true,
				},

				----------------------------------------------------------------
				-- 🌱 Git status
				----------------------------------------------------------------
				git_status = {
					window = {
						position = "float",
					},
				},
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>e", ":Neotree float toggle<CR>", { desc = "Neotree float" })
			vim.keymap.set("n", "<leader>E", ":Neotree left toggle<CR>", { desc = "Neotree toggle" })
			vim.keymap.set("n", "<leader>ge", function()
				require("neo-tree.command").execute({ source = "git_status", toggle = true })
			end, { desc = "Git Explorer" })

			vim.keymap.set("n", "<leader>be", function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true })
			end, { desc = "Buffer Explorer" })
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = true,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					bo = {
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
}
