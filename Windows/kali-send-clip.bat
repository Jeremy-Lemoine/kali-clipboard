@echo off

REM ----------------------------------------------------------------------------
REM              CONFIGURE HERE THE FOLDERS USED BY THE SCRIPTS                 
REM ----------------------------------------------------------------------------

set temporary_folder=C:\Users\jerem\scripts\.tmp

set kali_temporary_folder=/home/kali/Documents/Host/.tmp

REM ----------------------------------------------------------------------------
REM                                MAIN SCRIPT                                  
REM ----------------------------------------------------------------------------

if not exist %temporary_folder% mkdir %temporary_folder%

if not exist "%temporary_folder%\kali-host-ip" (
    echo Kali IP Address not found. Running kali-ip.bat.
    call kali-ip.bat
    if not exist "%temporary_folder%\kali-host-ip" (
        echo Kali IP Address not found. Exiting.
        exit /b 1
    )
)

for /f "tokens=*" %%a in (%temporary_folder%\kali-host-ip) do set kali_ip=%%a

@REM IF YOUR CURL IS NOT IN THE EXPECTED PATH BUT EXISTS, CHANGE THE PATH HERE OR REMOVE THE 'IF' STATEMENT
if exist C:\Windows\System32\curl.exe (
    @REM IT CHECKS IF THE SSH SERVICE IS RUNNING ON THE KALI
    curl --connect-timeout 1 %kali_ip%:22 2>&1 | find "allowed" > nul 2>&1
    if errorlevel 1 (
        echo Either the SSH service is not running on the Kali, or the saved Kali's IP is outdated ^(try to run kali-ip.bat^).
        exit /b 1
    )
)

powershell -command "Get-Clipboard" > "%temporary_folder%\tmp-clip-host"

ssh root@%kali_ip% "mkdir -p %kali_temporary_folder%" > nul 2>&1
scp %temporary_folder%\tmp-clip-host root@%kali_ip%:%kali_temporary_folder%/tmp-clip-host > nul 2>&1

if %errorlevel% neq 0 (
    echo Failed to send the clipboard to the Kali. Check if SSH is started in Kali.
    del "%temporary_folder%\tmp-clip-host"
    exit /b 1
)

del "%temporary_folder%\tmp-clip-host"

echo Clipboard sent to the Kali.