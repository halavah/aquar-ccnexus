# ========================================
# New API - 管理脚本 (PowerShell)
# ========================================

# 设置控制台编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# 切换到脚本所在目录
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptPath

# 设置 bin 目录路径
$BIN_DIR = Join-Path $ScriptPath "bin"

# 检查 bin 目录是否存在
if (-not (Test-Path $BIN_DIR)) {
    Write-Host "[错误] bin 目录不存在: $BIN_DIR" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

# 主函数
function Show-MainMenu {
    while ($true) {
        Clear-Host
        Write-Host ""
        Write-Host "╔════════════════════════════════════════════════════════════╗"
        Write-Host "║  New API - 管理控制台"
        Write-Host "╚════════════════════════════════════════════════════════════╝"
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════"
        Write-Host "  项目管理"
        Write-Host "═══════════════════════════════════════════════════════════"
        Write-Host ""
        Write-Host "  1. 🚀 启动后端     (bin\start-backend.bat)"
        Write-Host ""
        Write-Host "  2. 🎨 启动前端     (bin\start-front.bat)"
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════"
        Write-Host ""
        Write-Host "  9. 🚪 退出"
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════"
        Write-Host ""

        $choice = Read-Host "请选择操作 [1-2, 9] (默认: 1)"

        # 如果用户直接按回车，默认选择 1
        if ([string]::IsNullOrWhiteSpace($choice)) {
            $choice = "1"
        }

        switch ($choice) {
            "1" {
                Write-Host ""
                Write-Host "╔════════════════════════════════════════════════════════════╗"
                Write-Host "║  执行: 启动后端"
                Write-Host "╚════════════════════════════════════════════════════════════╝"
                Write-Host ""

                $backendScript = Join-Path $BIN_DIR "start-backend.bat"
                & $backendScript

                Write-Host ""
                Write-Host "═══════════════════════════════════════════════════════════"
                Read-Host "按回车键继续"
            }
            "2" {
                Write-Host ""
                Write-Host "╔════════════════════════════════════════════════════════════╗"
                Write-Host "║  执行: 启动前端"
                Write-Host "╚════════════════════════════════════════════════════════════╝"
                Write-Host ""

                $frontScript = Join-Path $BIN_DIR "start-front.bat"
                & $frontScript

                Write-Host ""
                Write-Host "═══════════════════════════════════════════════════════════"
                Read-Host "按回车键继续"
            }
            "9" {
                Write-Host ""
                Write-Host "[信息] 感谢使用 Libra Boot Plus 管理控制台"
                Write-Host ""
                exit 0
            }
            default {
                Write-Host ""
                Write-Host "[错误] 无效的选项: $choice" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    }
}

# 启动主菜单
Show-MainMenu
