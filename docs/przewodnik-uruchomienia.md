# Przewodnik uruchomienia BTT Pi v1.2.1 z Klipperem

## Przygotowanie sprzętu

### Lista wymaganych elementów
- ✅ BTT Pi v1.2.1
- ✅ BTT SKR 3 EZ
- ✅ Karta microSD (min. 16GB, Class 10)
- ✅ Kabel USB-C do zasilania BTT Pi (5V/3A)
- ✅ Kabel USB-A do USB-C (BTT Pi → SKR 3 EZ)
- ✅ Zasilacz 12V/24V dla SKR 3 EZ
- ✅ Przewody połączeniowe do drukarki

## Krok 1: Przygotowanie karty SD

1. **Pobierz Raspberry Pi OS Lite**
   - Idź na stronę: https://www.raspberrypi.org/software/
   - Pobierz Raspberry Pi OS Lite (64-bit)

2. **Wgraj obraz na kartę SD**
   - Użyj Raspberry Pi Imager
   - Kliknij ikonę ⚙️ (ustawienia) przed zapisem
   
   **Wymagane ustawienia:**
   - ✅ **Ustaw hostname**: `bttpi.local`
   - ✅ **Ustaw login i hasło**: 
     - Login: `pi`
     - Hasło: [ustaw bezpieczne hasło]
   - ✅ **Skonfiguruj sieć Wi-Fi**:
     - SSID: [nazwa Twojej sieci]
     - Hasło: [hasło do Wi-Fi]
     - Kraj: **PL** (Polska)
   - ✅ **Ustawienia lokalizacji**:
     - Strefa czasowa: `Europe/Warsaw`
     - Układ klawiatury: `pl`
   - ✅ **Usługi (SSH)**:
     - ☑️ **Włącz SSH** (KONIECZNE!)
     - ⚪ **Używaj uwierzytelniania hasłem**

   **Zapisz obraz na kartę SD** - SSH jest już automatycznie skonfigurowane!

## Krok 2: Uruchomienie BTT Pi

1. **Fizyczne połączenia**
   - Włóż kartę SD do BTT Pi
   - Podłącz zasilanie USB-C (5V/3A)
   - Podłącz kabel Ethernet (opcjonalnie)

2. **Znalezienie adresu IP**
   
   **Sposób 1 - Hostname (najłatwiejszy):**
   ```bash
   # Jeśli skonfigurowałeś hostname na "bttpi"
   ping bttpi.local
   ```
   
   **Sposób 2 - Skanowanie sieci (macOS bez nmap):**
   ```bash
   # Sprawdź swoją sieć
   ipconfig getifaddr en0  # Wi-Fi
   ipconfig getifaddr en1  # Ethernet
   
   # Skanuj sieć (zastąp 192.168.1 swoją siecią)
   for i in {1..254}; do ping -c 1 -W 1000 192.168.1.$i &> /dev/null && echo "192.168.1.$i jest online"; done
   ```
   
   **Sposób 3 - Zainstaluj nmap:**
   ```bash
   # Homebrew (jeśli masz)
   brew install nmap
   
   # Potem użyj:
   nmap -sn 192.168.1.0/24 | grep -B 2 "Raspberry Pi"
   ```
   
   **Sposób 4 - Dodaj wpa_supplicant.conf (rozwiązanie problemu Wi-Fi):**
   ```bash
   # Edytuj przygotowany plik i dodaj swoje hasło Wi-Fi
   nano btt-pi/wpa_supplicant.conf
   
   # Skopiuj na kartę SD do partycji boot
   cp btt-pi/wpa_supplicant.conf /Volumes/bootfs/
   touch /Volumes/bootfs/ssh
   
   # Bezpiecznie wyjmij kartę
   diskutil unmount /Volumes/bootfs
   ```
   
   **Sposób 5 - Router:**
   - Wejdź na router (zwykle 192.168.1.1 lub 192.168.0.1)
   - Sprawdź podłączone urządzenia
   - Szukaj "bttpi" lub "Raspberry Pi"

3. **Pierwsza łączność SSH**
   ```bash
   ssh pi@IP_ADRES_BTT_PI
   ```

## Krok 3: Instalacja Klippera (automatyczna)

### Z tego projektu VS Code:
1. Otwórz VS Code
2. Naciśnij `Ctrl+Shift+P` → "Tasks: Run Task"
3. Wybierz "Instalacja Klippera na BTT Pi"

### Lub manualnie na BTT Pi:
```bash
# Skopiuj skrypt na BTT Pi
scp scripts/install-klipper.sh pi@IP_ADRES:/home/pi/

# Uruchom na BTT Pi
ssh pi@IP_ADRES
chmod +x install-klipper.sh
./install-klipper.sh
```

## Krok 4: Kompilacja firmware dla SKR 3 EZ

### Z VS Code:
1. `Ctrl+Shift+P` → "Tasks: Run Task"
2. Wybierz "Kompilacja firmware SKR 3 EZ"

### Lub manualnie na BTT Pi:
```bash
ssh pi@IP_ADRES
cd ~/klipper
make menuconfig
```

**Ustawienia konfiguracji:**
- Micro-controller: `STMicroelectronics STM32`
- Processor model: `STM32H743`
- Bootloader offset: `128KiB bootloader`
- Clock Reference: `25 MHz crystal`
- Communication interface: `USB (on PA11/PA12)`

```bash
make clean
make -j4
```

## Krok 5: Wgrywanie firmware do SKR 3 EZ

1. **Skopiuj firmware**
   ```bash
   # Na BTT Pi
   cp ~/klipper/out/klipper.bin /tmp/firmware.bin
   
   # Skopiuj na komputer
   scp pi@IP_ADRES:/tmp/firmware.bin ./firmware.bin
   ```

2. **Wgraj do SKR 3 EZ**
   - Skopiuj `firmware.bin` na kartę SD
   - Włóż kartę do SKR 3 EZ
   - Włącz zasilanie SKR 3 EZ
   - Poczekaj na wgranie (plik zmieni nazwę na `firmware.cur`)

## Krok 6: Połączenie SKR 3 EZ z BTT Pi

1. **Fizyczne połączenie**
   - Podłącz kabel USB-A (BTT Pi) → USB-C (SKR 3 EZ)

2. **Sprawdzenie połączenia**
   ```bash
   # Z VS Code task lub bezpośrednio:
   ssh pi@IP_ADRES "ls /dev/serial/by-id/"
   ```

3. **Konfiguracja printer.cfg**
   ```bash
   # Skopiuj konfigurację
   scp klipper/printer.cfg pi@IP_ADRES:~/printer_data/config/
   
   # Edytuj serial w pliku printer.cfg
   ssh pi@IP_ADRES
   nano ~/printer_data/config/printer.cfg
   # Zmień serial na właściwy z /dev/serial/by-id/
   ```

## Krok 7: Uruchomienie systemu

1. **Restart usług**
   ```bash
   ssh pi@IP_ADRES "sudo systemctl restart klipper"
   ssh pi@IP_ADRES "sudo systemctl restart nginx"
   ```

2. **Dostęp do interfejsu**
   - Otwórz przeglądarkę
   - Przejdź do: `http://IP_ADRES_BTT_PI`
   - Powinieneś zobaczyć interfejs Mainsail

## Diagnostyka problemów

### BTT Pi nie uruchamia się
- Sprawdź zasilanie (wymagane 5V/3A)
- Sprawdź kartę SD (sformatowanie, obraz)
- Sprawdź diodę LED statusu

### Klipper nie łączy się z SKR 3 EZ
```bash
# Sprawdź porty serial
ssh pi@IP_ADRES "ls /dev/serial/by-id/"

# Sprawdź status Klippera
ssh pi@IP_ADRES "sudo systemctl status klipper"

# Sprawdź logi
ssh pi@IP_ADRES "journalctl -u klipper -f"
```

### Brak dostępu do interfejsu web
```bash
# Sprawdź nginx
ssh pi@IP_ADRES "sudo systemctl status nginx"

# Sprawdź Moonraker
ssh pi@IP_ADRES "sudo systemctl status moonraker"
```

## Następne kroki

1. **Kalibracja drukarki**
   - PID tuning hot end i bed
   - Kalibracja kroków na mm
   - Bed leveling

2. **Dodatkowe funkcje**
   - Kamera (opcjonalnie)
   - Sensor filamentu
   - Auto bed leveling (BLTouch)

3. **Konfiguracja slicera**
   - Profil Klippera w PrusaSlicer/SuperSlicer
   - Makra start/end G-code

## Przydatne komendy VS Code

- `Ctrl+Shift+P` → "Tasks: Run Task" → "Sprawdź status Klippera"
- `Ctrl+Shift+P` → "Tasks: Run Task" → "Restart Klippera"
- `Ctrl+Shift+P` → "Tasks: Run Task" → "Sprawdź porty serial"