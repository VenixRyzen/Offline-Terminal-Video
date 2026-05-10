TerminalMedia Pro v4.8
Developed by Vexin/Lumiva

TerminalMedia Pro is a high-performance, neon-styled command-line station designed for seamless media discovery and storage management. It offers a professional-grade environment to search, download, and play media up to 4K resolution without the bloat of traditional software.

⚠️ Important User Notices
Playback Errors: If the library sends an error like "Check your internet connection," simply close the playback tab, open it back up, and try playing your video again.

Security Warning: Because this is a .bat file, Windows SmartScreen or Chrome may flag it as "unrecognized." Click "More Info" and then "Run Anyway" to start the station.

Storage Governor: Ensure you set your MB limit in the settings to prevent the software from exceeding your desired disk space.

Core Features
Pro Discovery: Batch download multiple videos via search or instant URL pasting.

Persistent Agent: A background worker that grabs trending media hourly at low bitrates to save data.

Auto-Memory: Your quality and storage settings are saved automatically every time you boot.

Integrated Library: Instant redirection to your downloaded files for immediate viewing.

Need Help?
Contact via Discord: akira.soul_ (if you need anything)
“High-speed media, zero bloat.” HOW TO SETUP!!! FIRST GO TO FILE EXPLORER. RIGHT-CLICK AND PICK NEW AND MAKE A NEW FOLDER! NAME IT TerminalMedia (most important!) THEN GO TO NOTEPAD AND PASTE THIS! : 





@echo off
setlocal enabledelayedexpansion
title TerminalMedia_Pro_v5.2
color 0B

:: --- 1. EMERGENCY BOOT SHIELD ---
if "%~1" neq "nopause" (
    cmd /c "%~f0" nopause
    pause
    exit /b
)

:: --- 2. CONFIG DEFAULTS ---
set "version=v5.2"
set "author=Vexin/Lumiva"
set "contact=Discord : akira.soul_ (if you need anything)"
set "engine=yt-dlp.exe"
set "lib=TerminalMedia"
set "conf=config.ini"
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
echo ================================================================================
echo                 TERMINAL MEDIA: PRO STATION                %version%
echo ================================================================================
echo  Made By %author%  ^|  Contact : %contact%
echo  STATUS: ONLINE   ^|  QUALITY: %q_name%
echo  STORAGE: %limit%MB LIMIT
echo ================================================================================
echo.
echo  [1] Discover  - Search and batch download
echo  [2] Instant   - Direct link download
echo  [3] Library   - View and Play your media
echo  [4] Settings  - Adjust Resolution ^& Storage Limit
echo  [5] Agent     - Background Persistent Downloader
echo.
echo  [Q] Exit Terminal
echo.
set /p main_opt="Station-Command >> "

if /i "%main_opt%"=="Q" exit /b
if "%main_opt%"=="1" goto trigger_discover
if "%main_opt%"=="2" goto trigger_instant
if "%main_opt%"=="3" goto library
if "%main_opt%"=="4" goto settings
if "%main_opt%"=="5" goto agent
goto home

:trigger_discover
call :check_storage
if %errorlevel% neq 0 goto home
goto discover

:trigger_instant
call :check_storage
if %errorlevel% neq 0 goto home
goto instant

:check_storage
set "bytes=0"
for /f "tokens=3" %%A in ('dir /s /-c "%lib%" 2^>nul ^| findstr /c:"bytes" ^| findstr /v "free"') do set "bytes=%%A"
set "cur_size=%bytes:~0,-6%"
if "%cur_size%"=="" set "cur_size=0"

if %cur_size% GTR %limit% (
    cls
    echo ==========================================================
    echo                 STORAGE LIMIT REACHED
    echo ==========================================================
    echo  "Your storage for video hitted the limit you adjusted."
    echo  "Please adjust the limit or delete some videos taht you dont need"
    pause
    exit /b 1
)
exit /b 0

:discover
cls
echo --- SEARCH DISCOVERY ---
set /p search="Enter Search Topic: "
set /p count="How many videos?: "
echo.
echo Downloading... please wait.
"%engine%" -f "bestvideo[height<=%res%]+bestaudio/best" --no-playlist --restrict-filenames --output "%lib%/%%(title)s.%%(ext)s" "ytsearch%count%:%search%"
echo.
echo Download Process Finished.
timeout /t 2 >nul
goto library

:instant
cls
echo --- INSTANT DOWNLOAD ---
set /p link="Paste Media URL: "
echo.
echo Downloading... please wait.
"%engine%" -f "bestvideo[height<=%res%]+bestaudio/best" --restrict-filenames --output "%lib%/%%(title)s.%%(ext)s" "%link%"
echo.
echo Download Process Finished.
timeout /t 2 >nul
goto library

:library
cls
echo ================================================================================
echo                                 TERMINAL LIBRARY                                
echo ================================================================================
echo  WARNING: If the video sends an error like check your internet connection. 
echo           Just close the tab and open back up and play your video back. 
echo ================================================================================
set count=0
for %%f in ("%lib%\*.*") do (
    set /a count+=1
    set "vid[!count!]=%%~ff"
    echo [!count!] %%~nxf
)
if %count%==0 (
    echo Library is empty.
    pause
    goto home
)
echo.
set /p play="Play ID (or B for Back) >> "
if /i "%play%"=="B" goto home
if defined vid[%play%] start "" "!vid[%play%]!" & goto library
goto library

:settings
cls
echo ==========================================================
echo                     STATION SETTINGS                      
echo ==========================================================
echo  [1] Adjust Resolution (Current: %q_name%)
echo  [2] Adjust Storage Limit (Current: %limit% MB)
echo  [3] Run Setup Wizard (Engine/FFmpeg Fix)
echo  [B] Back to Main Station
echo.
set /p s_opt=">> "
if /i "%s_opt%"=="B" goto home
if "%s_opt%"=="1" goto quality_menu
if "%s_opt%"=="2" goto limit_set
if "%s_opt%"=="3" goto setup_wizard
goto settings

:limit_set
echo.
set /p limit="Enter MB Limit >> "
goto save_cfg

:quality_menu
cls
echo [1] 4K Ultra HD  [2] 2K Quad HD  [3] 1080p Full HD
echo [4] 720p HD      [5] 480p SD       [6] 180p Data Saver
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

:agent
cls
(
echo @echo off
echo :loop
echo "%engine%" -f "bestvideo[height<=144]+bestaudio/best" --no-playlist --output "%lib%/%%%%(title)s.%%%%(ext)s" "ytsearch1:trending"
echo timeout /t 3600
echo goto loop
) > agent_run.bat
start /min agent_run.bat
pause
goto home

:setup_wizard
cls
echo [1] Get Engine (yt-dlp) [2] Get High-Speed FFmpeg [B] Back
set /p wiz=">> "
if "%wiz%"=="1" curl -L "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -o "%engine%"
if "%wiz%"=="2" (
    echo Downloading Standalone FFmpeg...
    curl -L "https://github.com/eugeneware/ffmpeg-static/releases/latest/download/ffmpeg-win32-x64" -o "ffmpeg.exe"
    echo Done!
)
goto home

THEN GO PRESS THE "FILE" ON THE NOTEPAD AND PICK SAVE AS AS GO TO THE FOLDER YOU CREATED AND PICK FILE TYPE : ALL-FILES AND NAME IT setup.bat AND PICK ANIS INSTEAD OF UTP-8 ON THE SAVE AS. THEN GO TO THE FOLDER AND PRESS ON THE setup AND YOU WILL GET THE TERMINAL NOW PRESS 4 AND ENTER AND PRESS THE DOWNLOAD TO DOWNLOAD FFMPEG FOR AUDIO THEN WAIT FOR AWHILE UNTIL IT FINALLY LOADS! THEN THERE YOU GO!

How to use? Type the number(option) then press Enter.
