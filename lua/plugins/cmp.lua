return {
      {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path", 
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
 
            cmp.setup({
                performance = {
                    debounce = 60,
                    throttle = 30,
                    fetching_timeout = 500,
                    confirm_resolve_timeout = 80,
                    async_budget = 1,
                    max_view_entries = 200,
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', priority = 1000 },
                    { name = 'luasnip', priority = 750 },
                }, {
                    { name = 'buffer', priority = 500, max_item_count = 5 },
                    { name = "path", priority = 250 },
                }),
            })
        end,
    }, 
    {
      "neovim/nvim-lspconfig"
    }
}
