return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- Define your servers here. LazyVim handles the Mason installation 
            -- and the LSP attachment automatically.
            servers = {
                pyright = {},
                lua_ls = {},
                rust_analyzer = {},
                jdtls = {},
                ts_ls = {},
                html = {},
                cssls = {},
                -- Note: clangd is already safely configured in your cpp.lua!
            },
        },
    },
}