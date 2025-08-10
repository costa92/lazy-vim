return {
      {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "hrsh7th/cmp-buffer", event = "InsertEnter" },
            { "hrsh7th/cmp-path", event = "InsertEnter" },
            { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
            { "L3MON4D3/LuaSnip", event = "InsertEnter" },
            { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
        },
        config = function()
            local cmp = require("cmp")
 
            cmp.setup({
                performance = {
                    debounce = 150,
                    throttle = 60,
                    fetching_timeout = 500,
                    max_view_entries = 20,
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
                    { name = 'buffer', priority = 500, keyword_length = 3 },
                    { name = "path", priority = 250 },
                }),
            })
        end,
    }, 
    {
      "neovim/nvim-lspconfig"
    }
}
