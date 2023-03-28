@echo off

REM ----------------------------------------------------------------------------
REM              CONFIGURE HERE THE FOLDERS USED BY THE SCRIPTS                 
REM ----------------------------------------------------------------------------

set temporary_folder=C:\Users\jerem\scripts\.tmp

REM ----------------------------------------------------------------------------
REM                                MAIN SCRIPT                                  
REM ----------------------------------------------------------------------------

set command="get-vm -Name Kali | select -ExpandProperty networkadapters | select ipaddresses | Format-List | Out-File -FilePath %temporary_folder%\kali-host-ip -Encoding utf8"

@REM THIS IS THE LINE ASKING FOR ADMINISTRATOR RIGHTS WHEN THE SCRIPT IS LAUNCHED
powershell -command "Start-Process powershell -Verb runAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "%command%"'"

@REM THIS PART IS TO FORMAT THE OUTPUT OF THE PREVIOUS COMMAND TO GET ONLY THE IP ADDRESS
powershell -command "(Get-Content %temporary_folder%\kali-host-ip | Select-String -Pattern '\d{1,3}(\.\d{1,3}){3}' -AllMatches).Matches.Value | Out-File -FilePath %temporary_folder%\kali-host-ip -Encoding utf8"
powershell -command "$MyPath = '%temporary_folder%\kali-host-ip' ; $MyRawString = Get-Content -Raw $MyPath ; $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False ; [System.IO.File]::WriteAllLines($MyPath, $MyRawString, $Utf8NoBomEncoding) ; (Get-Content $MyPath) + [char]0x0a | Set-Content -NoNewline $MyPath"

echo Kali IP Address found (saved in %temporary_folder%\kali-host-ip).
