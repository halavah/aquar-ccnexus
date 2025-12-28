# 说明：仅启动前端 dev（默认 5173），不会启动后端。
# 若需后端，请单独运行 start-backend.ps1（端口 3000）。

# 设置脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
Push-Location $RootDir

# 检查 bun 是否安装
$bunCmd = Get-Command bun -ErrorAction SilentlyContinue
if (-not $bunCmd) {
    Write-Host "[错误] bun not found, please install bun (https://bun.sh)" -ForegroundColor Red
    Pop-Location
    exit 1
}

# 设置默认端口
if (-not $env:WEB_PORT) {
    $env:WEB_PORT = "5173"
}

# 杀掉占用端口的进程
$port = $env:WEB_PORT
$processes = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Where-Object { $_.State -eq "Listen" }
foreach ($proc in $processes) {
    $process = Get-Process -Id $proc.OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Killing process on port $port (PID $($process.Id))..."
        Stop-Process -Id $process.Id -Force
    }
}

# 首次运行时安装依赖
if (-not (Test-Path "web\node_modules")) {
    Write-Host "Installing frontend dependencies (first run only)..."
    Push-Location web
    bun install
    Pop-Location
}

Write-Host "Starting frontend..."
Push-Location web
bun run dev -- --host 0.0.0.0 --port $env:WEB_PORT $args
Pop-Location

Pop-Location
