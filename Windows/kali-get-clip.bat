@echo off

REM ----------------------------------------------------------------------------
REM              CONFIGURE HERE THE FOLDERS USED BY THE SCRIPTS                 
REM ----------------------------------------------------------------------------

set temporary_folder=C:\Users\jerem\scripts\.tmp

set kali_temporary_folder=/home/kali/Documents/Host/.tmp

REM ----------------------------------------------------------------------------
REM                                MAIN SCRIPT                                  
REM ----------------------------------------------------------------------------

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

scp root@%kali_ip%:%kali_temporary_folder%/tmp-clip-kali %temporary_folder%\tmp-clip-kali > nul 2>&1

if not exist "%temporary_folder%\tmp-clip-kali" (
    echo Nothing has been sent by the Kali.
    exit /b 1
)

ssh root@%kali_ip% "rm %kali_temporary_folder%/tmp-clip-kali"

powershell -command "Get-Content %temporary_folder%\tmp-clip-kali | Set-Clipboard"
echo Fetched the clipboard sent by the Kali.

del "%temporary_folder%\tmp-clip-kali"