# 確保輸出編碼為 UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "        GitHub Pages Project Deploy Tool" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 指定 Visual Studio 內建的 git.exe 路徑
$gitPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe"

if (-not (Test-Path $gitPath)) {
    Write-Host "[Error] Cannot find Git executable!" -ForegroundColor Red
    exit 1
}

Write-Host "[1/5] Initializing local Git repository..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    & $gitPath init -b main
}

Write-Host "[2/5] Setting Git user info..." -ForegroundColor Yellow
& $gitPath config user.name "Tnoso80133"
& $gitPath config user.email "Tnoso80133@users.noreply.github.com"

Write-Host "[3/5] Committing changes..." -ForegroundColor Yellow
& $gitPath add .
& $gitPath commit -m "Initialize AgentCoding portfolio web page"

Write-Host "[4/5] Setting Git remote..." -ForegroundColor Yellow
# 檢查遠端 remote 是否存在
$remoteCheck = & $gitPath remote
if ($remoteCheck -contains "origin") {
    & $gitPath remote remove origin
}
& $gitPath remote add origin "https://github.com/Tnoso80133/AgentCoding.git"

Write-Host "[5/5] Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "---------------------------------------------"
Write-Host "Hint: If the repository does not exist yet," -ForegroundColor DarkYellow
Write-Host "please go to https://github.com/new and create a public repository named 'AgentCoding'." -ForegroundColor DarkYellow
Write-Host "---------------------------------------------"

$pushSuccess = $false
while (-not $pushSuccess) {
    try {
        & $gitPath push -u origin main --force
        if ($LASTEXITCODE -eq 0) {
            $pushSuccess = $true
            Write-Host "[Success] Code pushed to GitHub successfully!" -ForegroundColor Green
        } else {
            throw "Push failed"
        }
    }
    catch {
        Write-Host "[Warning] Push failed. Please check if:" -ForegroundColor Yellow
        Write-Host "1. You have created a public repository named 'AgentCoding' on GitHub." -ForegroundColor White
        Write-Host "2. You have authenticated with GitHub (if prompted by Git Credential Manager)." -ForegroundColor White
        Write-Host "" -ForegroundColor White
        Write-Host "Once you have created the repository, press Enter to try pushing again..." -ForegroundColor Cyan
        Read-Host "Press Enter to retry"
    }
}

Write-Host "=============================================" -ForegroundColor Green
Write-Host "[Done] Repository deployment completed!" -ForegroundColor Green
Write-Host "Please follow these steps to enable GitHub Pages:" -ForegroundColor White
Write-Host "1. Go to: https://github.com/Tnoso80133/AgentCoding/settings/pages" -ForegroundColor Cyan
Write-Host "2. Under 'Source', select 'Deploy from a branch'" -ForegroundColor White
Write-Host "3. Under 'Branch', select 'main' and '/ (root)', then click 'Save'" -ForegroundColor White
Write-Host "4. Wait ~1 minute, then visit your portfolio at:" -ForegroundColor White
Write-Host "   https://Tnoso80133.github.io/AgentCoding/" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Green
