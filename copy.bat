@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ====================================
REM 批量目录复制脚本
REM Batch Directory Copy Script
REM ====================================
REM 
REM 功能：根据文件列表批量复制目录及其所有内容
REM 
REM 使用方法：
REM   1. 准备 filepaths.txt 文件（每行一个相对路径）
REM   2. 配置下方的源目录和目标目录
REM   3. 运行此脚本
REM 
REM 输出：
REM   - 屏幕显示：处理进度和统计报告
REM   - copy_log.txt：详细的复制日志
REM 
REM 版本：1.0
REM 日期：2025-10-28
REM ====================================

REM ====================================
REM 配置参数 - 请根据实际情况修改
REM ====================================

REM 目录列表文件（每行一个相对路径，相对于 SOURCE_ROOT）
set "FILEPATHS_FILE=filepaths.txt"

REM 源根目录（所有要复制的目录的根路径）
set "SOURCE_ROOT=D:\ceshiCopy\mxuploadpath\mxuploadpath\T_FLOW_ACCFILE"

REM 目标根目录（备份文件将保存到这里）
set "BACKUP_ROOT=D:\backup_root\mxuploadpath\mxuploadpath\T_FLOW_ACCFILE"

REM 日志文件名
set "LOG_FILE=copy_log.txt"

REM Start logging
echo ================================== > "%LOG_FILE%"
echo Copy Script Log >> "%LOG_FILE%"
echo Start time: %date% %time% >> "%LOG_FILE%"
echo ================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

echo ====================================
echo Batch Directory Copy Script
echo ====================================
echo.

REM Check if filepaths.txt exists
if not exist "%FILEPATHS_FILE%" (
    echo [ERROR] File list not found: %FILEPATHS_FILE%
    pause
    exit /b 1
)
echo [OK] Found filepaths.txt

REM Check if source directory exists
if not exist "%SOURCE_ROOT%" (
    echo [ERROR] Source directory does not exist: %SOURCE_ROOT%
    pause
    exit /b 1
)
echo [OK] Source directory exists

REM Create backup root directory if it doesn't exist
if not exist "%BACKUP_ROOT%" (
    mkdir "%BACKUP_ROOT%"
)

REM Initialize counters
set DIR_COUNT=0
set SUCCESS_COUNT=0
set FAILED_COUNT=0
set SKIPPED_COUNT=0

echo ====================================
echo Starting directory copy process
echo ====================================
echo Source: %SOURCE_ROOT%
echo Target: %BACKUP_ROOT%
echo ====================================
echo.

REM Read directory paths line by line
for /f "usebackq tokens=*" %%D in ("%FILEPATHS_FILE%") do (
    set /a DIR_COUNT+=1
    set "REL_DIR=%%D"
    
    if not "!REL_DIR!"=="" (
        REM Remove trailing backslash if exists
        if "!REL_DIR:~-1!"=="\" set "REL_DIR=!REL_DIR:~0,-1!"
        
        set "SOURCE_DIR=%SOURCE_ROOT%\!REL_DIR!"
        set "TARGET_DIR=%BACKUP_ROOT%\!REL_DIR!"
        
        echo [!DIR_COUNT!] !REL_DIR!
        echo [!DIR_COUNT!] !REL_DIR! >> "%LOG_FILE%"
        
        REM Check if source directory exists
        if exist "!SOURCE_DIR!" (
            echo   Copying...
            echo   SRC: !SOURCE_DIR! >> "%LOG_FILE%"
            echo   TGT: !TARGET_DIR! >> "%LOG_FILE%"
            
            REM Use robocopy to copy directory recursively
            REM /COPY:DAT = Copy Data, Attributes, Timestamps (no admin rights needed)
            robocopy "!SOURCE_DIR!" "!TARGET_DIR!" /E /COPY:DAT /R:5 /W:10 /NP >> "%LOG_FILE%" 2>&1
            
            set ROBO_EXIT=!errorlevel!
            
            REM robocopy exit codes: 0-3 = SUCCESS, 4+ = FAILED
            if !ROBO_EXIT! lss 4 (
                set /a SUCCESS_COUNT+=1
                echo   [OK] Exit code: !ROBO_EXIT!
                echo   [OK] Exit code: !ROBO_EXIT! >> "%LOG_FILE%"
            ) else (
                set /a FAILED_COUNT+=1
                echo   [FAILED] Exit code: !ROBO_EXIT!
                echo   [FAILED] Exit code: !ROBO_EXIT! >> "%LOG_FILE%"
            )
        ) else (
            set /a SKIPPED_COUNT+=1
            echo   [SKIPPED] Source not found
            echo   [SKIPPED] Source not found >> "%LOG_FILE%"
        )
        echo.
        echo. >> "%LOG_FILE%"
    )
)

REM Output statistics
echo ====================================
echo Copy Complete - Summary Report
echo ====================================
echo Total directories processed: %DIR_COUNT%
echo Directories not found:       %SKIPPED_COUNT%
echo Successfully copied:         %SUCCESS_COUNT%
echo Failed to copy:              %FAILED_COUNT%
echo ====================================
echo.

echo ================================== >> "%LOG_FILE%"
echo Summary Report >> "%LOG_FILE%"
echo ================================== >> "%LOG_FILE%"
echo Total directories processed: %DIR_COUNT% >> "%LOG_FILE%"
echo Directories not found:       %SKIPPED_COUNT% >> "%LOG_FILE%"
echo Successfully copied:         %SUCCESS_COUNT% >> "%LOG_FILE%"
echo Failed to copy:              %FAILED_COUNT% >> "%LOG_FILE%"
echo End time: %date% %time% >> "%LOG_FILE%"
echo ================================== >> "%LOG_FILE%"

echo Log file saved to: %LOG_FILE%
echo.
echo Press any key to exit...
pause >nul
