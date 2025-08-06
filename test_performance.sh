#!/bin/bash
# Neovim 性能测试脚本

echo "📊 Neovim 性能测试开始..."

# 测试启动时间
echo "🚀 测试启动时间..."
nvim --startuptime startup_optimized.log --headless -c q

# 提取启动时间
startup_time=$(grep "NVIM STARTED" startup_optimized.log | awk '{print $2}')
echo "✅ 优化后启动时间: ${startup_time}ms"

# 对比优化前后
if [ -f startup_analysis.log ]; then
    old_time=$(grep "NVIM STARTED" startup_analysis.log | awk '{print $2}')
    echo "📈 优化前启动时间: ${old_time}ms"
    
    # 计算改进幅度
    improvement=$(echo "$old_time - $startup_time" | bc -l 2>/dev/null || echo "计算失败")
    if [[ "$improvement" != "计算失败" ]]; then
        echo "⚡ 性能提升: ${improvement}ms"
    fi
fi

# 清理临时文件
rm -f startup_optimized.log

echo "🎉 性能测试完成!"