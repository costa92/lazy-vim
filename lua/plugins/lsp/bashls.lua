-- Bash/Shell 语言服务器配置
return function(setup_server)
  setup_server("bashls", {
    filetypes = { "sh", "bash", "zsh" },
  })
end

