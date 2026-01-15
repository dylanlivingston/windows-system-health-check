@echo off
setlocal

echo ============================================
echo Windows System Health Check
echo ============================================
echo.

set SCRIPT_DIR=%~dp0
set PS_SCRIPT=%SCRIPT_DIR%system-health-check.ps1

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

echo.
echo If successful, a report was saved to your Desktop (or Temp folder).
echo.
pause
endlocal
