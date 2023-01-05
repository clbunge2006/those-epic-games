@echo off
set __ACTIVE_DIR__=%~dp0
set __COMMAND_MODE__=%1
:: DEBUGGING LINE, PLEASE IGNORE	echo File Location: %__ACTIVE_DIR__%

if NOT EXIST "%__ACTIVE_DIR__%\epicgames-freebies-claimer\data\device_auths.json" (
    echo [45m
    echo Setup has not been completed, device_auths.json is missing from the data folder.
    echo   [0m
    sleep 3
    exit /b -1
)

if NOT [%1]==[] (
    npm run --prefix %__ACTIVE_DIR__%/epicgames-freebies-claimer
    exit /b 0
)

goto check_Permissions

:create_Task
    :: Create a vbs file which will start bat file in background
    IF EXIST "%__ACTIVE_DIR__%\run.vbs" DEL /F "%__ACTIVE_DIR__%\run.vbs"
    echo Dim WinScriptHost >> "%__ACTIVE_DIR__%\run.vbs"
    echo Set WinScriptHost = CreateObject("WScript.Shell") >> "%__ACTIVE_DIR__%\run.vbs"
    echo WinScriptHost.Run "%__ACTIVE_DIR__%\run.bat __RUN__", 0 >> "%__ACTIVE_DIR__%\run.vbs"
    echo Set WinScriptHost = Nothing >> "%__ACTIVE_DIR__%\run.vbs"

    SchTasks /Create /SC DAILY /TN "TEMP_CEF" /TR "%__ACTIVE_DIR__%\run.vbs" /ST 00:00
    :: Weird syntax needed to enable hidden mode
    IF EXIST "%__ACTIVE_DIR__%\TEMP_CEF.xml" DEL /F "%__ACTIVE_DIR__%\TEMP_CEF.xml"
    SchTasks /Query /XML /TN "TEMP_CEF" >> "%__ACTIVE_DIR__%\TEMP_CEF.xml"
    powershell -Command "(gc %__ACTIVE_DIR__%\TEMP_CEF.xml) -replace '<Settings>', '<Settings> <Hidden>true</Hidden>' | Out-File %__ACTIVE_DIR__%\TEMP_CEF.xml"
    SchTasks /Delete /TN "TEMP_CEF" /f
    SchTasks /Query /TN "Claim Epic Games Freebies" >NUL 2>&1 && SchTasks /Delete /TN "Claim Epic Games Freebies" /f
    SchTasks /Create /XML "%__ACTIVE_DIR__%\TEMP_CEF.xml" /TN "Claim Epic Games Freebies" 
    exit /b 0 

:check_Permissions
    echo [36mAdministrative permissions required. Detecting permissions...[0m
    
    net session >nul 2>&1
    if NOT %errorLevel% == 0 (
        echo [41m
	echo:
	echo Failure: Administrative permissions denied. Please run this script as an administrator. You are free to read over the .bat file if you do not trust it.
	echo [0m
	sleep 3
	exit /b -1
    )

    echo [32mSucess: Administrative permissions confirmed.[0m
    goto create_Task  
    
