@echo off
cd /d "%~dp0"
love .
if errorlevel 1 (
  echo.
  echo LÖVE not found. Install from https://love2d.org/
  echo Or: winget install love2d.love2d
  pause
)
