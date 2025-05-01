@echo off
powershell.exe -ExecutionPolicy Bypass -File "%~dp0pf.ps1"
exit /b %errorlevel%