@echo off
setlocal enabledelayedexpansion
title TerminalMedia_Pro_v4.8
color 0B

:: --- 1. EMERGENCY BOOT SHIELD ---
if "%~1" neq "nopause" (
    cmd /c "%~f0" nopause
    pause
    exit /b
)

:: --- 2. CONFIG DEFAULTS ---
set "version=v4.8"
set "author=Vexin/Lumiva"
set "contact=Discord : akira.soul_ (if you need anything)"
set "engine=yt-dlp.exe"
set "lib=TerminalMedia"
set "log=history.log"
set "conf=config.ini"
set "threads=16"
set "res=1080"
set "limit=5000"
set "q_name=1080p Full HD"

:: --- 3. AUTO-BUILD ---
if not exist "%lib%" mkdir "%lib%"

:: --- 4. CONFIG LOADER ---
if exist "%conf%" (
    for /f "usebackq tokens=1,2 delims==" %%a in ("%conf%") do (
        if "%%a"=="res" set "res=%%b"
        if "%%a"=="limit" set "limit=%%b"
        if "%%a"=="q_name" set "q_name=%%b"
    )
)

:home
cls
echo  [94m================================================================================[0m
echo  [96m                TERMINAL MEDIA: PRO STATION               [0m [90m%version%[0m
echo  [94m================================================================================[0m
echo  [90m Made By %author%  ^|  Contact : %contact%[0m
echo  [97m STATUS: [92mONLINE[0m   ^|  [97mQUALITY: [33m%q_name%[0m
echo  [97m STORAGE: [31m%limit%MB LIMIT[0m  ^|  [97mTHREADS: [36m%threads%[0m
echo  [94m================================================================================[0m
echo.
echo  [32m[1] Discover[0m  - Search and batch download
echo  [32m[2] Instant[0m   - Direct link download
echo  [33m[3] Library[0m   - View and Play your media
echo  [35m[4] Settings[0m  - Adjust Resolution ^& Storage Limit
echo  [36m[5] Agent[0m     - Background Persistent Downloader
echo.
echo  [91m[Q] Exit Terminal[0m
echo.
set /p main_opt="[97mStation-Command >> [0m"

if /i "%main_opt%"=="Q" exit /b
if "%main_opt%"=="1" goto check_storage_discover
if "%main_opt%"=="2" goto check_storage_instant
if "%main_opt%"=="3" goto library
if "%main_opt%"=="4" goto settings
if "%main_opt%"=="5" goto agent
goto home

:settings
cls
echo  [95m==========================================================[0m
echo  [95m                    STATION SETTINGS                      [0m
echo  [95m==========================================================[0m
echo  [97m[1] Adjust Resolution (Current: %q_name%)[0m
echo  [97m[2] Adjust Storage Limit (Current: %limit% MB)[0m
echo  [97m[3] Run Setup Wizard (Engine/FFmpeg Fix)[0m
echo  [97m[B] Back to Main Station[0m
echo.
set /p s_opt=">> "
if /i "%s_opt%"=="B" goto home
if "%s_opt%"=="1" goto quality_menu
if "%s_opt%"=="2" goto limit_set
if "%s_opt%"=="3" goto setup_wizard
goto settings

:limit_set
echo.
echo  [93mEnter the maximum size allowed (MB):[0m
set /p limit="Enter MB Limit >> "
goto save_cfg

:quality_menu
cls
echo  [96m[1] 4K Ultra HD  [2] 2K Quad HD  [3] 1080p Full HD[0m
echo  [96m[4] 720p HD      [5] 480p SD       [6] 180p Data Saver[0m
set /p q_opt="Set Resolution >> "
if "%q_opt%"=="1" set "res=2160" & set "q_name=4K Ultra HD"
if "%q_opt%"=="2" set "res=1440" & set "q_name=2K Quad HD"
if "%q_opt%"=="3" set "res=1080" & set "q_name=1080p Full HD"
if "%q_opt%"=="4" set "res=720"  & set "q_name=720p HD"
if "%q_opt%"=="5" set "res=480"  & set "q_name=480p SD"
if "%q_opt%"=="6" set "res=180"  & set "q_name=180p Data Saver"

:save_cfg
(
    echo res=%res%
    echo limit=%limit%
    echo q_name=%q_name%
) > "%conf%"
goto settings

:check_storage_discover
set "cur_size=0"
for /f "tokens=3" %%A in ('dir /s /-c "%lib%" 2^>nul ^| findstr /c:"bytes" ^| findstr /v "free"') do set "bytes=%%A"
if not defined bytes set "bytes=0"
set /a cur_size=%bytes:~0,-6% 2>nul
if %cur_size% GTR %limit% (
    cls
    echo  [91m"Your storage for video hitted the limit you adjusted."[0m
    echo  [91m"Please adjust the limit or delete some videos taht you dont need"[0m
    pause
    goto home
)
goto discover

:check_storage_instant
set "cur_size=0"
for /f "tokens=3" %%A in ('dir /s /-c "%lib%" 2^>nul ^| findstr /c:"bytes" ^| findstr /v "free"') do set "bytes=%%A"
if not defined bytes set "bytes=0"
set /a cur_size=%bytes:~0,-6% 2>nul
if %cur_size% GTR %limit% (
    cls
    echo  [91m"Your storage for video hitted the limit you adjusted."[0m
    echo  [91m"Please adjust the limit or delete some videos taht you dont need"[0m
    pause
    goto home
)
goto instant

:discover
cls
echo  [92m--- SEARCH DISCOVERY ---[0m
set /p search="Enter Search Topic: "
set /p count="How many videos?: "
"%engine%" -f "bestvideo[height<=%res%]+bestaudio/best" --no-playlist --restrict-filenames --output "%lib%/%%(title)s.%%(ext)s" "ytsearch%count%:%search%"
echo.
echo  [92mDownload Complete. Redirecting to Library...[0m
timeout /t 2 >nul
goto library

:instant
cls
echo  [92m--- INSTANT DOWNLOAD ---[0m
set /p link="Paste Media URL: "
"%engine%" -f "bestvideo[height<=%res%]+bestaudio/best" --restrict-filenames --output "%lib%/%%(title)s.%%(ext)s" "%link%"
echo.
echo  [92mDownload Complete. Redirecting to Library...[0m
timeout /t 2 >nul
goto library

:library
cls
echo  [93m================================================================================[0m
echo  [93m                                TERMINAL LIBRARY                                [0m
echo  [93m================================================================================[0m
echo  [91m WARNING: If the video sends an error like check your internet connection. [0m
echo  [91m          Just close the tab and open back up and play your video back. [0m
echo  [93m================================================================================[0m
set count=0
for %%f in ("%lib%\*.*") do (
    set /a count+=1
    set "vid[!count!]=%%~ff"
    echo  [97m[!count!] %%~nxf[0m
)
if %count%==0 (
    echo  [91mLibrary is currently empty.[0m
    pause
    goto home
)
echo.
echo  Select ID to Play or [B] to return to Main Station.
set /p play="Play ID >> "
if /i "%play%"=="B" goto home
if defined vid[%play%] (
    start "" "!vid[%play%]!"
    goto library
)
goto library

:agent
cls
echo  [36m--- BACKGROUND AUTO-AGENT ---[0m
(
echo @echo off
echo :loop
echo "%engine%" -f "bestvideo[height<=144]+bestaudio/best" --no-playlist --output "%lib%/%%%%(title)s.%%%%(ext)s" "ytsearch1:trending"
echo timeout /t 3600
echo goto loop
) > agent_run.bat
start /min agent_run.bat
echo  [36mAgent is now active in background.[0m
pause
goto home

:setup_wizard
cls
echo  [91m!!! IMPORTANT !!![0m
echo  [1] Get Engine (yt-dlp)
echo  [2] Get Audio Fixer (FFmpeg)
echo  [B] Back
set /p wiz=">> "
if "%wiz%"=="1" curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -o "%engine%"
if "%wiz%"=="2" (
    powershell -Command "Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile 'ff.zip'"
    powershell -Command "Expand-Archive -Path 'ff.zip' -DestinationPath 'temp_ff' -Force"
    for /r "temp_ff" %%i in (ffmpeg.exe) do move /y "%%i" "."
    rd /s /q "temp_ff" & del ff.zip
)
goto home