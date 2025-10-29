-- HTML 语言服务器配置
return function(setup_server)
  setup_server("html", {
    filetypes = { "html", "htmldjango" },
  })
end

