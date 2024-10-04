@echo off

Setlocal EnableDelayedExpansion

REM Konfigurationsdatei einlesen
set "configFile=config.txt"
set "useorderreader=1"
if not exist "%configFile%" (
    echo Konfigurationsdatei %configFile% nicht gefunden.
                timeout /t -1
    exit /b 1
)

REM Variablen aus der Konfigurationsdatei laden
for /f "delims=" %%a in (%configFile%) do (
    set "line=%%a"
    if "!line!" neq "" if "!line:~0,1!" neq "#" (
        set "line=!line: =!"
        for /f "tokens=1,2 delims==" %%b in ("!line!") do set "%%b=%%c"
    )
)

REM Überprüfe, ob nur der erste Benutzer definiert ist (kein mail2, mail3 usw.)
if defined mail2 (
    REM Mehrere Benutzer vorhanden, Benutzer-Auswahl anzeigen
    echo Wähle den Benutzer:
    echo [1] Benutzer 1
    echo [2] Benutzer 2
    echo [3] Benutzer 3
    echo [4] Benutzer 4
    echo [5] Benutzer 5
    set /p "userChoice=Gib die Nummer des Benutzers ein (1-5): "
) else (
    REM Nur der erste Benutzer definiert, Benutzer 1 automatisch auswählen
    echo Nur Benutzer 1 definiert. Abfrage wird übersprungen.
    set "userChoice=1"
)

REM E-Mail und Passwort basierend auf der Auswahl setzen
if "!userChoice!"=="1" (
    set "mail=!mail1!"
    set "passwort=!passwort1!"
    set "quellordner=!quellordner1!"
    set "dateiname=!dateiname1!"
    set "branch=!branch1!"
                set "useorderreader=!useorderreader1!"
) else if "!userChoice!"=="2" (
    set "mail=!mail2!"
    set "passwort=!passwort2!"
    set "quellordner=!quellordner2!"
    set "dateiname=!dateiname2!"
    set "branch=!branch2!"
                set "useorderreader=!useorderreader2!"
) else if "!userChoice!"=="3" (
    set "mail=!mail3!"
    set "passwort=!passwort3!"
    set "quellordner=!quellordner3!"
    set "dateiname=!dateiname3!"
    set "branch=!branch3!"
                set "useorderreader=!useorderreader3!"
) else if "!userChoice!"=="4" (
    set "mail=!mail4!"
    set "passwort=!passwort4!"
    set "quellordner=!quellordner4!"
    set "dateiname=!dateiname4!"
    set "branch=!branch4!"
                set "useorderreader=!useorderreader4!"
) else if "!userChoice!"=="5" (
    set "mail=!mail5!"
    set "passwort=!passwort5!"
    set "quellordner=!quellordner5!"
    set "dateiname=!dateiname5!"
    set "branch=!branch5!"
                set "useorderreader=!useorderreader5!"
) else (
    echo Ungueltige Auswahl. Skript wird beendet.
    exit /b 1
)

echo Benutzer: !mail!
echo Passwort: ****
echo Quellordner: !quellordner!
echo Dateiname: !dateiname!
echo Branch: !branch!

REM Definiere die Quell- und Zielordner sowie den Dateinamen
set "ProgrammPfad=C:\Program Files (x86)\OrderReader\OrderReader.exe"
set "Zielordner=%~dp0"
set "Link=https://ecarelink.ch/app#/orders"
set "Datei=!Zielordner!!Dateiname!"

REM Setze den Ordnerpfad relativ zum Speicherort des Skripts
set "ResponseFolder=%~dp0archive"

REM Prüfe, ob der Ordner existiert, und erstelle ihn, falls nicht
if not exist "!ResponseFolder!" (
    mkdir "!ResponseFolder!"
)

REM Setze die Datei-Pfade für die Antwort und den HTTP-Status
set "ResponseFile=!ResponseFolder!\curl_response.json"
set "StatusFile=!ResponseFolder!\http_status.txt"

REM TEMP-Verzeichnis anzeigen
echo Response-Verzeichnis: !ResponseFolder!

REM Überprüfen, ob Dateien im Quellordner existieren und kopieren oder überspringen
for %%f in (!Quellordner!\!Dateiname!) do (
    if exist "%%f" (
        echo Datei gefunden: %%f
        move /Y "%%f" "!Zielordner!"
        echo Datei %%f wurde nach "!Zielordner!" verschoben.
    ) else (
        echo Keine Dateien gefunden, die dem Muster !Dateiname! entsprechen. Programm wird geschlossen.
        timeout /t 10
        exit /b 1
    )
)

for %%f in (!Zielordner!!Dateiname!) do (
    if exist "%%f" (
REM Entferne Leerzeichen aus dem Dateinamen
        set "origFileName=%%~nxf"
        set "newFileName=!origFileName: =!"
        
        echo Bereinigter Dateiname: !newFileName!
                               ren "%%f" "!newFileName!"
     ) else (
                               echo keine datei zum bereinigen
                )
                )


:progcheck
REM Prüfe, ob das Programm existiert
if exist "!ProgrammPfad!" (
    if "!useorderreader!"=="1" (
        goto pruefe
    ) else (
        goto Curl
    )
) else (
    goto Curl
)
:Curl

REM Senden des XML-Inhalts im Body mit Content-Type application/xml
for %%f in (!Zielordner!!Dateiname!) do (
                
    echo Sende Datei: %%f
    curl -F file=@%%f !branch! -u !mail!:!passwort! -w %%{http_code} -o !ResponseFile! -s > !StatusFile!
                
                REM timeout /t -1    
                for /f "delims=" %%a in ('type "!ResponseFile!"') do (
    set "Antwort=%%a"
                )
                REM timeout /t -1
    REM Lese den HTTP-Statuscode aus der Datei
    set /p status=<"!StatusFile!"
    echo HTTP Status: !status!

    REM Prüfe, ob der HTTP-Statuscode 200 ist
    if "!status!"=="200" (
        echo Datei %%f erfolgreich hochgeladen.
        
        REM Lese den Inhalt der JSON-Antwort und extrahiere die Referenznummer
        for /f "tokens=2 delims=#" %%a in ('findstr /C:"Versand: #" "!ResponseFile!"') do set "referenz=%%a"
        
        echo Referenznummer: !referenz!

        REM Füge die Referenznummer zum Link hinzu
        set "Link=https://ecarelink.ch/app#/orders/"

        REM Öffne den aktualisierten Link im Browser
        echo Öffne Link: !Link!
        start "" "!Link!"

        REM Datei nach erfolgreicher Übermittlung löschen
        del "%%f"
    ) else (
        echo Fehler beim Hochladen der Datei %%f. Status: !status!
    )

)

goto ende

:pruefe

set "ProgrammName=orderreader.exe"

REM Überprüfe, ob das Programm bereits gestartet ist
tasklist | find /i "%ProgrammName%" >nul
if errorlevel 1 (
    echo Programm nicht gestartet
    start /min "" "%ProgrammPfad%"
) else (
    echo Das Programm ist bereits gestartet.
)

timeout /t 5

if exist "!Datei!" (
    echo Datei existiert, mache A
    goto Curl
) else (
    echo Datei existiert nicht, mache B
    goto ende
)

:ende
cls
if defined referenz ( 
    echo Bestellnummer: !referenz!
                del !ResponseFile!
    del !StatusFile!
    timeout /t 4
) else (
    echo !Antwort!
    
    REM Lösche die alten Dateien
    del !ResponseFile!
    del !StatusFile!
    
    REM Erstelle eine zufällige Zahl für den Dateinamen
    set /a randNum=%random%
    for %%F in ("!Datei!") do set "Dateiendung=%%~xF"
    
    REM Kopiere die Datei mit einem zufälligen Namen in den ResponseFolder
    copy !Datei! !ResponseFolder!\failed_Transfer_!randNum!!Dateiendung!
    timeout /t -1
)
Endlocal
exit
