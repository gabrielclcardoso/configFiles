return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- CRITICAL: You must be on the main branch for Neovim 0.12
    build = ":TSUpdate",
    config = function()
        -- 1. Use the plugin ONLY to download your parsers
        require("nvim-treesitter").install({
            "json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
            "markdown",
			"markdown_inline",
			"bash",
			"lua",
			"vim",
			"vimdoc",
            "dockerfile",
			"gitignore",
			"query",
			"python",
        })

        -- 2. Use NATIVE Neovim to actually do the highlighting
        -- This tells Neovim: "Every time I open a file, turn on native Treesitter"
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
            callback = function()
                -- pcall prevents errors if you open a filetype you haven't downloaded a parser for yet
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
