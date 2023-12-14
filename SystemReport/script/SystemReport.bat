@echo off
setlocal enabledelayedexpansion

@REM -----
@REM �ݒ�
@REM -----
@REM �t�@�C���o�̓t�H���_�[�i��K�w��j
set "OUTPUT_DIR=%~dp0.."
for %%i in ("%OUTPUT_DIR%") do set "OUTPUT_DIR=%%~fi\"

@REM �J�����g�f�B���N�g�����t�@�C���o�͐�ɕύX
cd /d %OUTPUT_DIR%

@REM �t�@�C����
set "YMD=%DATE:~-10,4%%DATE:~-5,2%%DATE:~-2,2%"
set "HMS=%TIME: =0%"
set "HMS=%HMS:~0,2%%HMS:~3,2%%HMS:~6,2%"
set "OUTPUT_FILENAME=SystemReport_%YMD%_%HMS%.txt"

@REM -----
@REM ����
@REM -----
echo �����W��...
@REM �ȍ~�̕W���o�́i����/�ُ�j���t�@�C���֏o��
(
    echo [Is Run Admin]
    whoami /priv | find "SeDebugPrivilege" > nul
    if !errorlevel! neq 0 (
        echo �W�����[�U�[�Ŏ��s���܂����B
    ) else (
        echo �Ǘ��Ҍ������[�U�[�Ŏ��s���܂����B
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

echo �����t�@�C���F%OUTPUT_DIR%%OUTPUT_FILENAME%
endlocal

pause
