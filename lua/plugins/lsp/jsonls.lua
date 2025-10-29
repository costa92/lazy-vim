-- JSON 语言服务器配置
return function(setup_server)
  setup_server("jsonls", {
    filetypes = { "json", "jsonc" },
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  })
end

