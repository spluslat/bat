@echo off
setlocal enabledelayedexpansion

@REM 実行するバッチ
set "RUN_BAT_PATH=.\script\SystemReport.bat"

@REM カレントディレクトリ変更
cd /d %~dp0

@REM 実行するバッチが存在するかチェックする
if not exist "%RUN_BAT_PATH%" (
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Write-Host -ForegroundColor Red 'エラー：バッチファイルが存在しないため、処理を終了します。'"
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Write-Host -ForegroundColor Red 'バッチファイル：%RUN_BAT_PATH%'"
    pause
    exit
)

@REM 管理者権限での実行を要求する
@REM 管理者権限の取得に失敗/拒否された場合は、標準ユーザーとして実行する
whoami /priv | find "SeDebugPrivilege" > nul
if !errorlevel! neq 0 (
    @REM 標準ユーザー
    @REM 管理者権限の実行を試す
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Start-Process '%RUN_BAT_PATH%' -Verb RunAs"
    if !errorlevel! neq 0 (
        @REM 管理者権限の取得に失敗/拒否された場合は、標準ユーザーとして実行する
        call %RUN_BAT_PATH%
    )
) else (
    @REM 管理者権限ユーザーのため、そのまま実行する
    call %RUN_BAT_PATH%
)

endlocal
