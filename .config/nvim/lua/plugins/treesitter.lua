return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Lazy load on file open for better startup time
    event = { "BufReadPost", "BufNewFile" }, 
    opts = function(_, opts)
      -- Merge ensure_installed safely with any existing distro defaults
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })

      -- Automatically install missing parsers when entering buffer
      opts.auto_install = true

      -- Highlighting
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      -- Disable standard vim regex highlighting to save CPU and prevent clash
      opts.highlight.additional_vim_regex_highlighting = false

      -- Indentation
      opts.indent = opts.indent or {}
      opts.indent.enable = true
    end,
  },

  -- Treesitter context line at the top of the window
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },
  },
}
