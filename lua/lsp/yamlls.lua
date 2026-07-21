-- YAML 语言服务器配置
return {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://json.schemastore.org/docker-compose.yml"] = "/docker-compose*.yml",
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
        ["https://json.schemastore.org/gitlab-ci.json"] = "/.gitlab-ci.yml",
      },
      validate = true,
      completion = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
    },
  },
}
