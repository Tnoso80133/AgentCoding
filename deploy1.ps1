# 確保輸出編碼為 UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "    Bento Box / Aurora UI Project Deployer" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 指定 Visual Studio 內建的 git.exe 路徑
$gitPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe"

if (-not (Test-Path $gitPath)) {
    Write-Host "[Error] Cannot find Git executable!" -ForegroundColor Red
    exit 1
}

Write-Host "[1/4] Ensuring Git repository is initialized..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    & $gitPath init -b main
}

Write-Host "[2/4] Committing new Bento Box page files..." -ForegroundColor Yellow
& $gitPath add .
& $gitPath commit -m "Deploy Bento style page index1.html using ui-ux-pro-max-skill"

Write-Host "[3/4] Ensuring remote origin is correct..." -ForegroundColor Yellow
$remoteCheck = & $gitPath remote
if ($remoteCheck -contains "origin") {
    & $gitPath remote remove origin
}
& $gitPath remote add origin "https://github.com/Tnoso80133/AgentCoding.git"

Write-Host "[4/4] Pushing updates to GitHub..." -ForegroundColor Yellow
try {
    # 執行推送 (由於前一次已授權，本次應能直接完成)
    & $gitPath push -u origin main --force
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n=============================================" -ForegroundColor Green
        Write-Host "🎉 [Success] Updates pushed to GitHub successfully!" -ForegroundColor Green
        Write-Host "Your new Bento Box page is ready!" -ForegroundColor White
        Write-Host "👉 https://Tnoso80133.github.io/AgentCoding/index1.html" -ForegroundColor Cyan
        Write-Host "=============================================" -ForegroundColor Green
    } else {
        throw "Push failed"
    }
}
catch {
    Write-Host "[Error] Failed to push to GitHub. Please check your credentials." -ForegroundColor Red
}
