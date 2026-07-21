-- JSON 语言服务器配置
return {
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
