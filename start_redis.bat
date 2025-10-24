@echo off
title Redis Server
echo ========================================
echo   Starting Redis Server
echo ========================================
echo.
echo Redis akan berjalan di:
echo   Host: 127.0.0.1
echo   Port: 6379
echo.
echo Jangan tutup window ini!
echo ========================================
echo.

redis-server.exe redis.windows.conf
