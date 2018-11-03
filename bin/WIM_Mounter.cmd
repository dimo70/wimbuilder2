if "x%3"=="x" goto :EOF
if not "x%~4"=="x" set %~4=

call WB_LOG "[%WB_PROJECT%] --- MOUNT [%~1:%2] -%%gt:%% [%~3]"

rem remove uncompleted mounted folder first.
set chk_file=
if exist "%~3" (
    for /f "delims=" %%i in ('dir /b "%~3"') do (
        set "chk_file=%%i"
    )
)

if "x%chk_file%"=="x" (
    rd /q "%~3"
)
set chk_file=

if not exist "%~3" mkdir "%~3"
call DismX /mount-wim /wimfile:"%~1" /index:%2 /mountdir:"%~3"

if "x%~4"=="x" goto :EOF
if "%errorlevel%"=="0" set %~4=1