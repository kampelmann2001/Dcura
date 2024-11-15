@echo off
setlocal

REM Überprüfen, ob die Datei cred.txt existiert
if not exist cred.txt (
    echo Die Datei "cred.txt" wurde nicht gefunden. Bitte erstellen Sie die Datei mit den zu codierenden Inhalten.
    pause
    exit /b 1
)

REM Base64-kodierte Datei erzeugen
certutil -encode cred.txt temp_encoded.txt >nul

REM Den Base64-String auslesen und in einer Variablen speichern
set "encodedString="
for /f "skip=1 delims=" %%A in (temp_encoded.txt) do (
    if not "%%A"=="" (
        set "encodedString=%%A"
        goto :showResult
    )
)

:showResult
REM Den Base64-kodierten String anzeigen
echo Base64-kodierter String: %encodedString%

REM Temporäre Dateien löschen
del temp_encoded.txt

pause
endlocal
