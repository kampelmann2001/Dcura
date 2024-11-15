### Bedienungsanleitung für das Bestellsystem-Skript

#### 1. **Einleitung**
Dieses Skript wurde entwickelt, um Bestelldateien automatisch an das Bestellsystem eines Kunden zu übermitteln. Das Skript verwendet eine Konfigurationsdatei, in der die Zugangsdaten, Dateipfade und weitere Informationen für jeden Benutzer definiert sind. Die Konfiguration kann für bis zu fünf verschiedene Benutzer angepasst werden, und die Bestellung wird über eine sichere Schnittstelle (API) an den Server übermittelt.

#### 2. **Voraussetzungen**
- **Windows-PC**: Das Skript funktioniert auf Windows-Systemen.
- **Netzwerkzugang**: Das Skript muss auf die Netzwerkordner zugreifen können, falls Bestelldateien in einem Netzwerk gespeichert sind.
- **Internetverbindung**: Eine stabile Internetverbindung ist erforderlich, um die Bestelldaten an den Server zu übermitteln.
- **Installierte Software**: Das Skript setzt voraus, dass `curl` installiert ist (dies ist standardmäßig in Windows 10/11 vorhanden) und gegebenenfalls das Programm "OrderReader" (optional, je nach Konfiguration).

#### 3. **Vorbereitung der Installation**

1. **Konfigurationsdatei (`config.txt`) anpassen**:
   - Die Konfigurationsdatei enthält die spezifischen Einstellungen für jeden Benutzer.
   - Bearbeite die Datei, indem du für jeden Benutzer die E-Mail-Adresse (`mailX`), das Passwort (`passwortX`), den Pfad zum Quellordner (`quellordnerX`), den Dateinamen der Bestelldatei (`dateinameX`), die Branch-URL (`branchX`) und die Einstellung für den OrderReader (`useorderreaderX`) festlegst.
Wird nur die erste Email definiert erfolgt keine Benutzerabfrage. Sonst erfragt das script beim ausführen den benutzer für den übermittelt werden soll. 
Für den Fall das für mehrere Benutzer übermittelt werden soll, müssen diese im Script noch benannt werden, damit dem User bei der Auswahl nicht die generischen Namen angezeigt werden sondern die realen:

Scriptausschnitt
***
echo Wähle den Benutzer:
    echo [1] Benutzer 1
    echo [2] Benutzer 2
    echo [3] Benutzer 3
    echo [4] Benutzer 4
    echo [5] Benutzer 5
****

   
   **Beispiel-Konfiguration**:
   ```
   mail1=test@test.com
   passwort1=testtest1
   b641=baseausdruckderzugangsdatenerstelltvonencobat
   quellordner1=C:\einquellordner
   dateiname1=Trans*.dat
   branch1=galexis.com
   useorderreader1=0
   ```
   - **Erläuterungen**:
     - **`mailX`**: Die E-Mail-Adresse des Benutzers, die für die Authentifizierung beim Hochladen der Datei verwendet wird.
     - **`passwortX`**: Das zugehörige Passwort.
     - **`quellordnerX`**: Der Ordner, in dem die Bestelldatei auf dem Rechner des Kunden abgelegt ist.
     - **`dateinameX`**: Der Dateiname oder das Dateimuster (z.B. `*.dat`), das für die Bestelldatei verwendet wird.
     - **`branchX`**: Der URL-Teil des Servers, an den die Datei gesendet wird (z.B. `galexis.com` oder pharmapool.ch).
     - **`useorderreaderX`**: Gibt an, ob der OrderReader verwendet werden soll (0 = nein, 1 = ja).

2. **Skript vorbereiten**:
   - Stelle sicher, dass sich das Skript (`batch`-Datei) und die Konfigurationsdatei im gleichen Verzeichnis befinden.
   - Überprüfe, dass der OrderReader korrekt installiert ist (falls erforderlich) und der Pfad in der Konfigurationsdatei angegeben ist.

#### 4. **Ausführung des Skripts**

1. **Start des Skripts**:
   - Öffne die Eingabeaufforderung (cmd.exe) und navigiere zu dem Ordner, in dem sich das Skript und die Konfigurationsdatei befinden.
   - Führe das Skript durch Eingabe des Skriptnamens aus: `bestellsystem.bat`

2. **Benutzer auswählen**:
   - Wenn mehr als ein Benutzer in der Konfigurationsdatei definiert ist, erscheint eine Abfrage, bei der du den gewünschten Benutzer durch Eingabe der entsprechenden Nummer auswählst (z.B. 1 für Benutzer 1).
   - Wenn nur ein Benutzer definiert ist, wird die Abfrage automatisch übersprungen, und das Skript verwendet die Konfiguration dieses Benutzers.

3. **Dateiübertragung**:
   - Das Skript überprüft, ob die im Quellordner angegebene Bestelldatei vorhanden ist.
   - Falls Leerzeichen im Dateinamen sind, entfernt das Skript diese automatisch.
   - Die Datei wird an die entsprechende URL gesendet (abhängig von der Branch-Einstellung).
   - Nach erfolgreicher Übermittlung wird die Datei gelöscht.

#### 5. **Fehlerbehebung**

1. **Fehler: Konfigurationsdatei nicht gefunden**:
   - Stelle sicher, dass die Konfigurationsdatei `config.txt` im gleichen Verzeichnis wie das Skript liegt.

2. **Fehler: Keine Bestelldateien gefunden**:
   - Überprüfe, ob der Pfad in `quellordnerX` korrekt ist und ob die Dateimusterangabe in `dateinameX` richtig gesetzt wurde.

3. **Fehler: Verbindung zum Server nicht möglich**:
   - Überprüfe, ob der Server (z.B. `galexis.com`) erreichbar ist und die Internetverbindung stabil ist.
   - Vergewissere dich, dass die Zugangsdaten (E-Mail und Passwort) korrekt sind.

4. **Fehler beim OrderReader**:
   - Falls der OrderReader verwendet wird, prüfe, ob das Programm installiert ist und der korrekte Pfad in der Konfigurationsdatei angegeben wurde.

#### 6. **Verwendungsszenarien**

- **Einzelbenutzer**: Wenn du das Skript bei einem Kunden mit nur einem Benutzer installierst, kannst du die Benutzerabfrage überspringen, indem du nur den ersten Benutzer in der Konfigurationsdatei definierst.
- **Mehrere Benutzer**: In einem Szenario mit mehreren Benutzern wird das Skript bei jedem Start den Benutzer abfragen. Dies ist nützlich, wenn das Skript für mehrere Personen auf demselben Gerät verwendet wird.

#### 7. **Wartung und Anpassungen**

- Änderungen an den E-Mail-Adressen, Passwörtern, Quellordnern oder Dateinamen können jederzeit in der `config.txt`-Datei vorgenommen werden.
- Falls sich die Branch-URL oder andere Server-Details ändern, passe die Konfigurationsdatei entsprechend an.

#### 8. **Sicherheitshinweise**
- Die Passwörter werden in der Konfigurationsdatei im Klartext gespeichert. Sorge dafür, dass diese Datei nur für autorisierte Personen zugänglich ist.
- Stelle sicher, dass keine sensiblen Informationen in ungesicherten Netzwerken übertragen werden. Verwende sichere Verbindungen (SSL/TLS).

#### 9. **Abschluss**
Dieses Skript erleichtert das automatische Hochladen von Bestelldateien. Mit der Konfigurationsdatei können die Einstellungen flexibel angepasst werden, sodass verschiedene Benutzer das Skript leicht nutzen können.

