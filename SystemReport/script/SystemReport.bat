@echo off
setlocal enabledelayedexpansion

@REM -----
@REM 設定
@REM -----
@REM ファイル出力フォルダー（一階層上）
set "OUTPUT_DIR=%~dp0.."
for %%i in ("%OUTPUT_DIR%") do set "OUTPUT_DIR=%%~fi\"

@REM カレントディレクトリをファイル出力先に変更
cd /d %OUTPUT_DIR%

@REM ファイル名
set "YMD=%DATE:~-10,4%%DATE:~-5,2%%DATE:~-2,2%"
set "HMS=%TIME: =0%"
set "HMS=%HMS:~0,2%%HMS:~3,2%%HMS:~6,2%"
set "OUTPUT_FILENAME=SystemReport_%YMD%_%HMS%.txt"

@REM -----
@REM 処理
@REM -----
echo 情報収集中...
@REM 以降の標準出力（正常/異常）をファイルへ出力
(
    echo [Is Run Admin]
    whoami /priv | find "SeDebugPrivilege" > nul
    if !errorlevel! neq 0 (
        echo 標準ユーザーで実行しました。
    ) else (
        echo 管理者権限ユーザーで実行しました。
    )

    echo.
    echo [Account Info]
    @REM net user %USERNAME%
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property Name, UserName, Domain"

    echo.
    echo [System Info]
    systeminfo

    echo.
    echo [HDD Info]
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Get-PSDrive -PSProvider FileSystem | Format-Table -AutoSize -Wrap | Out-String -Width 10000"

    echo.
    echo [Services Info]
    @REM PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Get-Service | Format-Table -AutoSize"
    @REM PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Get-CimInstance -ClassName Win32_Service -Filter 'Name = ''W3SVC'' OR Name LIKE ''%sql%''' | Format-Table -AutoSize -Wrap | Out-String -Width 10000"
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Get-CimInstance -ClassName Win32_Service | Format-Table -AutoSize -Wrap | Out-String -Width 10000"

) > %OUTPUT_FILENAME% 2>&1

echo 生成ファイル：%OUTPUT_DIR%%OUTPUT_FILENAME%
endlocal

pause
