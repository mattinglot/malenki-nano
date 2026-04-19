@echo off
setlocal

if "%~1"=="" (
  echo Usage: %~n0 COMx
  echo Example: %~n0 COM3
  exit /b 1
)
set PORT=%~1

REM ==== avrdude / avrdude.conf autodetect ====
REM Old hardcoded paths from previous machine, kept for reference:
REM set AVRDUDE=C:\Users\Matt\AppData\Local\Arduino15\packages\DxCore\tools\avrdude\6.3.0-arduino17or18\bin\avrdude.exe
REM set AVRCONF=C:\Users\Matt\AppData\Local\Arduino15\packages\megaTinyCore\hardware\megaavr\2.6.10\avrdude.conf

set "ARDUINO15=%LOCALAPPDATA%\Arduino15\packages"
set "AVRDUDE="
set "AVRCONF="

REM Prefer DxCore -> megaTinyCore -> stock Arduino for avrdude.exe
if exist "%ARDUINO15%\DxCore\tools\avrdude" (
  for /r "%ARDUINO15%\DxCore\tools\avrdude" %%F in (avrdude.exe) do if exist "%%F" set "AVRDUDE=%%F"
)
if not defined AVRDUDE if exist "%ARDUINO15%\megaTinyCore\tools\avrdude" (
  for /r "%ARDUINO15%\megaTinyCore\tools\avrdude" %%F in (avrdude.exe) do if exist "%%F" set "AVRDUDE=%%F"
)
if not defined AVRDUDE if exist "%ARDUINO15%\arduino\tools\avrdude" (
  for /r "%ARDUINO15%\arduino\tools\avrdude" %%F in (avrdude.exe) do if exist "%%F" set "AVRDUDE=%%F"
)

REM Prefer megaTinyCore -> DxCore -> stock Arduino for avrdude.conf
if exist "%ARDUINO15%\megaTinyCore\hardware\megaavr" (
  for /r "%ARDUINO15%\megaTinyCore\hardware\megaavr" %%F in (avrdude.conf) do if exist "%%F" set "AVRCONF=%%F"
)
if not defined AVRCONF if exist "%ARDUINO15%\DxCore\hardware\megaavr" (
  for /r "%ARDUINO15%\DxCore\hardware\megaavr" %%F in (avrdude.conf) do if exist "%%F" set "AVRCONF=%%F"
)
if not defined AVRCONF if exist "%ARDUINO15%\arduino\tools\avrdude" (
  for /r "%ARDUINO15%\arduino\tools\avrdude" %%F in (avrdude.conf) do if exist "%%F" set "AVRCONF=%%F"
)

if not defined AVRDUDE (
  echo ERROR: avrdude.exe not found. Install Arduino IDE with megaTinyCore, DxCore, or stock AVR boards.
  exit /b 1
)
if not defined AVRCONF (
  echo ERROR: avrdude.conf not found. Install Arduino IDE with megaTinyCore, DxCore, or stock AVR boards.
  exit /b 1
)

echo Using avrdude: %AVRDUDE%
echo Using conf:    %AVRCONF%
echo Port:          %PORT%
echo.
echo "UFuse2 0x02 means 20mhz, which is what Malenki firmware is hardcoded to use"
echo "UFuse5 EESave (save EEPROM on flash) on, Full CRC checks"
echo "Fuse6 8ms delay between power on and code execution"

"%AVRDUDE%" -C"%AVRCONF%" -v -pattiny1616 -cjtag2updi -P%PORT% -b115200 -Ufuse0:w:0b00000000:m -Ufuse2:w:0x02:m -Ufuse5:w:0b11000101:m -Ufuse6:w:0x04:m -Ufuse7:w:0x00:m -Ufuse8:w:0x00:m -Uflash:w:main.hex:i

endlocal
