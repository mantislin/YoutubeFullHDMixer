@ECHO OFF
:: -----------------------------------------------------------------------------
:MAIN       -- MAIN PROGRAM
::          -- Enumerate .mp4 files without recursively, and will to try to
::          -- find a audio stream file to mix with, like .m4a file, then
::          -- output as .mp4 file.
SETLOCAL ENABLEDELAYEDEXPANSION

set "mp4box=%~sdp0mp4box\MP4Box.exe"

for /f "usebackq tokens=* delims=" %%a in (`dir/b/a-d "*.mp4"`) do (
    SETLOCAL DISABLEDELAYEDEXPANSION
    set "fnameN=%%~na"
    SETLOCAL ENABLEDELAYEDEXPANSION

    echo/
    echo/!fnameN!
    echo/------------------------------

    ::Extract .m4a audio stream from .mp4 file if it doesn't exist
    if not exist "!fnameN!.m4a" ( if exist "!fnameN!.mp4" (
        "%mp4box%" -raw 2 "!fnameN!.mp4" -out "!fnameN!.m4a"
    ))

    ::Remix .mp4 and .m4a to .mp4 file, overwrites the exists one.
    if exist "!fnameN!.m4a" (
        rem "%mp4box%" -add "!fnameN!.mp4:fps=60:delay=0:name=!fnameN!.mp4" -add "!fnameN!.m4a:delay=0:name=!fnameN!.m4a" -new "!fnameN!.mp4"
        "%mp4box%" -add "!fnameN!.mp4:delay=0:name=!fnameN!.mp4" -add "!fnameN!.m4a:delay=0:name=!fnameN!.m4a" -new "!fnameN!.muxed.mp4" && (
            del/q/f "!fnameN!.m4a" "!fnameN!.mp4"
        )
    )

    ENDLOCAL
    ENDLOCAL
)

ENDLOCAL
EXIT/B
