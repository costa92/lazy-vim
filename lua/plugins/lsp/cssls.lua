-- CSS 语言服务器配置
return function(setup_server)
  setup_server("cssls", {
    filetypes = { "css", "scss", "less" },
  })
end

