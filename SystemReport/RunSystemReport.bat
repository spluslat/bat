@echo off
setlocal enabledelayedexpansion

@REM ���s����o�b�`
set "RUN_BAT_PATH=.\script\SystemReport.bat"

@REM �J�����g�f�B���N�g���ύX
cd /d %~dp0

@REM ���s����o�b�`�����݂��邩�`�F�b�N����
if not exist "%RUN_BAT_PATH%" (
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Write-Host -ForegroundColor Red '�G���[�F�o�b�`�t�@�C�������݂��Ȃ����߁A�������I�����܂��B'"
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Write-Host -ForegroundColor Red '�o�b�`�t�@�C���F%RUN_BAT_PATH%'"
    pause
    exit
)

@REM �Ǘ��Ҍ����ł̎��s��v������
@REM �Ǘ��Ҍ����̎擾�Ɏ��s/���ۂ��ꂽ�ꍇ�́A�W�����[�U�[�Ƃ��Ď��s����
whoami /priv | find "SeDebugPrivilege" > nul
if !errorlevel! neq 0 (
    @REM �W�����[�U�[
    @REM �Ǘ��Ҍ����̎��s������
    PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "Start-Process '%RUN_BAT_PATH%' -Verb RunAs"
    if !errorlevel! neq 0 (
        @REM �Ǘ��Ҍ����̎擾�Ɏ��s/���ۂ��ꂽ�ꍇ�́A�W�����[�U�[�Ƃ��Ď��s����
        call %RUN_BAT_PATH%
    )
) else (
    @REM �Ǘ��Ҍ������[�U�[�̂��߁A���̂܂܎��s����
    call %RUN_BAT_PATH%
)

endlocal
