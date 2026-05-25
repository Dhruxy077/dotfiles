return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true, -- Enable Treesitter integration
            ts_config = {
                lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
                javascript = { "template_string" }, -- Don't add pairs in JS template strings
            },
        })

        -- NOTE: Removed nvim-cmp integration because Dhruvim uses blink.cmp!
    end,
}