# 说明：仅启动后端（go run main.go），不会启动前端 dev。
# 日志中的 Local/Network (3000) 是后端自带静态站点提示，不代表前端 dev 已启动；如需前端，请运行 start-front.ps1（默认 5173）。

# 设置脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
Push-Location $RootDir

# 设置默认端口
if (-not $env:PORT) {
    $env:PORT = "3000"
}

# 检查 Go 是否安装
$goCmd = Get-Command go -ErrorAction SilentlyContinue
if (-not $goCmd) {
    Write-Host "[错误] Go not found, please install Go toolchain" -ForegroundColor Red
    Pop-Location
    exit 1
}

# 杀掉占用端口的进程
$port = $env:PORT
$processes = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Where-Object { $_.State -eq "Listen" }
foreach ($proc in $processes) {
    $process = Get-Process -Id $proc.OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Killing process on port $port (PID $($process.Id))..."
        Stop-Process -Id $process.Id -Force
    }
}

Write-Host "Starting backend..."
go run main.go $args

Pop-Location
