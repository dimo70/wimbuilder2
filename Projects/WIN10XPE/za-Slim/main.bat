rem replace small files

if "x%opt[slim.font.mingliu]%"=="xtrue" (
  del /f /a /q "%X_WIN%\Fonts\mingliu.ttc"
)

if "x%opt[slim.small_fonts]%"=="xtrue" (
  for /f "delims=" %%i in ('dir /b SmallFonts') do (
    if exist "%X_WIN%\Fonts\%%i" copy /Y "%~dp0SmallFonts\%%i" "%X_WIN%\Fonts\"
  )
)

if "x%opt[slim.small_imageresdll]%"=="xtrue" (
    if exist "%~dp0small_imageres.dll" xcopy  /E /Y "%~dp0SmallFonts\small_imageres.dll"  %X_SYS%\imageres.dll
)

set opt[component.hta]=false
if exist "%X_SYS%\mshta.exe" (
  set opt[component.hta]=true
) else (
  set opt[slim.hta]=false
)

set opt[component.speech]=false
if exist "%X_WIN%\Speech" (
  set opt[component.speech]=true
) else (
  set opt[slim.speech]=false
  set opt[slim.narrator]=false
)

if "x%opt[slim.speech]%"=="xtrue" (
  set opt[slim.narrator]=true
)

set opt[component.narrator]=false
if exist "%X_SYS%\Narrator.exe" (
  set opt[component.narrator]=true
) else (
  set opt[slim.narrator]=false
)

rem services management extended page needs jscript.dll,jscript9.dll,mshtml.dll

set mmc_required=0
if "x%opt[component.mmc]%"=="xtrue" (
  if not "x%opt[shell.app]%"=="xwinxshell" (
    set mmc_required=1
  )
)

if "x%opt[slim.jscript]%"=="xtrue" (
  del /a /f /q "%X_SYS%\Chakra.dll"
  del /a /f /q "%X_SYS%\Chakradiag.dll"
  del /a /f /q "%X_SYS%\Chakrathunk.dll"

  if %mmc_required% EQU 0 (
    del /a /f /q "%X_SYS%\jscript.dll"
    del /a /f /q "%X_SYS%\jscript9.dll"
  )

  del /a /f /q "%X_SYS%\jscript9diag.dll"
)

if "x%opt[component.bitlocker]%"=="xtrue" (
  rem bitlocker feature needs HTA and WMI
  rem set opt[slim.hta]=false
  set opt[slim.wmi]=false
)

if "x%opt[slim.hta]%"=="xtrue" (
  del /a /f /q "%X_SYS%\mshta.exe"

  if %mmc_required% EQU 0 (
    del /a /f /q "%X_SYS%\mshtml.dll"
  )
  del /a /f /q "%X_SYS%\mshtml.tlb"
  del /a /f /q "%X_SYS%\mshtmled.dll"
  call :DEL_CATLOG WinPE-HTA-Package "*"
)
set mmc_required=

if "x%opt[slim.wmi]%"=="xtrue" (
  del /a /f /q "%X_SYS%\wmi*"
  del /a /f /q "%X_SYS%\%WB_PE_LANG%\wmi*"
  rem disk management
  if not "x%opt[component.mmc]%"=="xtrue" (
    del /a /f /q "%X_SYS%\wbem\wmi*"
    del /a /f /q "%X_SYS%\wbem\%WB_PE_LANG%\wmi*"
  )
  call :DEL_CATLOG "WMI,StorageWMI,WMIProvider,WmiClnt"
)

if "x%opt[slim.speech]%"=="xtrue" (
  rd /s /q "%X_WIN%\Speech"
  rd /s /q "%X_SYS%\Speech"
  del /a /f /q "%X_SYS%\SRH.dll"
  del /a /f /q "%X_SYS%\srhelper.dll"
  del /a /f /q "%X_SYS%\srms*.dat"
  call :DEL_CATLOG "SRT,SRH,Speech"

  rem narrator.exe
  del /a /f /q "%X_SYS%\Narrator*"
  del /a /f /q "%X_SYS%\%WB_PE_LANG%\Narrator*"
  call :DEL_CATLOG WinPE-Narrator-Package "*"
)

if "x%opt[slim.dism]%"=="xtrue" (
  rd /s /q "%X_SYS%\Dism"
  del /f /a /q "%X_SYS%\dism.exe"
)

call main_Ultra.bat

rem already removed in _pre_wim.bat
goto :EOF

call :REMOVE_MUI Windows\Boot\EFI
call :REMOVE_MUI Windows\Boot\PCAT
call :REMOVE_MUI Windows\System32
goto :EOF

:REMOVE_MUI
rem always keep en-US
call :_REMOVE_MUI "%~1" "ar-SA bg-BG cs-CZ da-DK de-DE el-GR en-GB es-ES es-MX et-EE fi-FI fr-CA fr-FR"
call :_REMOVE_MUI "%~1" "he-IL hr-HR hu-HU it-IT ja-JP ko-KR  lt-LT lv-LV nb-NO nl-NL pl-PL pt-BR pt-PT"
call :_REMOVE_MUI "%~1" "qps-ploc ro-RO ru-RU sk-SK sl-SI sr-Latn-RS sv-SE th-TH tr-TR uk-UA zh-CN zh-TW"
goto :EOF

:_REMOVE_MUI
for %%i in (%~2) do (
  if not "x%%i"=="x%WB_PE_LANG%" (if exist "%X%\%~1\%%i" rd /s /q "%X%\%~1\%%i")
)
goto :EOF

:DEL_CATLOG
set _CAT_FIX=-
if "x%~2"=="x*" set _CAT_FIX=
for %%i in (%~1) do (
  del /a /f /q "%X_SYS%\CatRoot\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\*%_CAT_FIX%%%i%_CAT_FIX%*"
)
goto :EOF
