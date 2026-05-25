return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	opts = function()
		local dashboard = require("alpha.themes.dashboard")

		-- Custom Dhruvim Logo
		local logo = [[
 ██████   █████ ██████████    ███████    █████   █████ █████ ██████   ██████
▒▒██████ ▒▒███ ▒▒███▒▒▒▒▒█  ███▒▒▒▒▒███ ▒▒███   ▒▒███ ▒▒███ ▒▒██████ ██████ 
 ▒███▒███ ▒███  ▒███  █ ▒  ███     ▒▒███ ▒███    ▒███  ▒███  ▒███▒█████▒███ 
 ▒███▒▒███▒███  ▒██████   ▒███      ▒███ ▒███    ▒███  ▒███  ▒███▒▒███ ▒███ 
 ▒███ ▒▒██████  ▒███▒▒█   ▒███      ▒███ ▒▒███   ███   ▒███  ▒███ ▒▒▒  ▒███ 
 ▒███  ▒▒█████  ▒███ ▒   █▒▒███     ███   ▒▒▒█████▒    ▒███  ▒███      ▒███ 
 █████  ▒▒█████ ██████████ ▒▒▒███████▒      ▒▒███      █████ █████     █████
▒▒▒▒▒    ▒▒▒▒▒ ▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒         ▒▒▒      ▒▒▒▒▒ ▒▒▒▒▒     ▒▒▒▒▒ 
                                                                            
                               N E O V I M
]]

		dashboard.section.header.val = vim.split(logo, "\n")

		-- Optimized buttons for Dhruvim
		dashboard.section.buttons.val = {
			dashboard.button("f", " " .. " Find File", "<cmd>Telescope find_files<cr>"),
			dashboard.button("r", " " .. " Recent Projects", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("g", " " .. " Live Grep", "<cmd>Telescope live_grep<cr>"),
			dashboard.button("s", " " .. " Resume Session", [[<cmd>lua pcall("persistence").load()<cr>]]),
			dashboard.button("c", " " .. " Dhruvim Config", "<cmd>edit $MYVIMRC<cr>"),
			dashboard.button("l", "󰒲 " .. " Manage Plugins", "<cmd>Lazy<cr>"),
			dashboard.button("q", " " .. " Exit Editor", "<cmd>qa<cr>"),
		}

		-- Styling colors (Matches standard Arch/Hyprland themes)
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		require("alpha").setup(dashboard.opts)

		-- Dhruvim Startup Stats
		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = "󱐋 Dhruvim initialized "
					.. stats.loaded
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
