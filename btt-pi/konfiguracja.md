# Konfiguracja BTT Pi v1.2.1

## Informacje o sprzęcie
- **Model**: BTT Pi v1.2.1
- **CPU**: Allwinner H3 Quad-Core ARM Cortex-A7
- **RAM**: 1GB DDR3
- **Storage**: microSD
- **Łączność**: Wi-Fi 2.4GHz, Ethernet 100Mbps
- **USB**: 2x USB 2.0, 1x USB-C (zasilanie)

## Schemat połączeń

### BTT Pi → SKR 3 EZ
- USB-A (BTT Pi) → USB-C (SKR 3 EZ)
- Zasilanie: USB-C 5V/3A do BTT Pi
- SKR 3 EZ: zasilanie 12V/24V zgodnie ze specyfikacją drukarki

### GPIO (opcjonalne)
BTT Pi ma dostępne piny GPIO dla dodatkowych funkcji:
- Pin 8 (GPIO14): TX UART
- Pin 10 (GPIO15): RX UART
- Pin 11 (GPIO17): GPIO ogólnego przeznaczenia
- Pin 12 (GPIO18): PWM
- Pin 13 (GPIO27): GPIO ogólnego przeznaczenia

## Konfiguracja sieci

### Wi-Fi
Edytuj plik `/etc/wpa_supplicant/wpa_supplicant.conf`:
```
network={
    ssid="NazwaTwojejSieci"
    psk="HasloDoSieci"
}
```

### Ethernet
Domyślnie skonfigurowany przez DHCP.

## Konfiguracja SSH

1. Włącz SSH:
```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

2. Zmień domyślne hasło:
```bash
passwd
```

3. Konfiguracja klucza SSH (opcjonalnie):
```bash
ssh-keygen -t rsa -b 4096
```

## Monitoring systemu

### Temperatura
```bash
vcgencmd measure_temp
```

### Obciążenie CPU
```bash
htop
```

### Przestrzeń dyskowa
```bash
df -h
```

## Optymalizacja wydajności

### Zwiększenie swap (dla kompilacji)
```bash
sudo dphys-swapfile swapoff
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=512/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### Ustawienia GPU memory split
```bash
echo 'gpu_mem=16' | sudo tee -a /boot/config.txt
```

## Rozwiązywanie problemów

### BTT Pi nie uruchamia się
1. Sprawdź zasilanie (5V/3A)
2. Sprawdź kartę SD (formatowanie, obraz)
3. Sprawdź diodę LED statusu

### Brak połączenia z SKR 3 EZ
1. Sprawdź kabel USB
2. Sprawdź port serial: `ls /dev/serial/by-id/`
3. Sprawdź uprawnienia: `sudo usermod -a -G dialout $USER`

### Problemy z siecią
1. Sprawdź konfigurację Wi-Fi
2. Restart interfejsu: `sudo ifdown wlan0 && sudo ifup wlan0`
3. Sprawdź status: `ip a`

## 🔧 Rozwiązanie problemu Wi-Fi: wpa_supplicant.conf

### Problem
Niektóre wersje Raspberry Pi OS nadal wymagają klasycznego pliku `wpa_supplicant.conf` w partycji boot, mimo że nowsze wersje używają `firstrun.sh`.

### Krok po kroku:

#### 1. Edytuj przygotowany plik wpa_supplicant.conf
```bash
# Otwórz plik i zmień hasło
nano btt-pi/wpa_supplicant.conf
```

**Zmień w pliku:**
```
ssid="Orange_Swiatlowod_4BB0"  # Twoja nazwa sieci
psk="TWOJE_PRAWDZIWE_HASLO"    # Twoje hasło Wi-Fi
```

#### 2. Skopiuj na kartę SD
```bash
# Włóż kartę SD do komputera
# Skopiuj plik do partycji boot
cp btt-pi/wpa_supplicant.conf /Volumes/bootfs/

# Dodaj pusty plik ssh dla pewności
touch /Volumes/bootfs/ssh

# Sprawdź czy pliki są na karcie
ls -la /Volumes/bootfs/{wpa_supplicant.conf,ssh,firstrun.sh}
```

#### 3. Bezpieczne wyjęcie karty
```bash
diskutil unmount /Volumes/bootfs
```

### ⚠️ WAŻNE zasady:
- Hasło Wi-Fi w cudzysłowach: `psk="haslo123"`
- Bez polskich znaków w haśle
- SSID dokładnie jak w routerze
- Kraj: `country=PL`

### Alternatywne konfiguracje:

**Dla ukrytej sieci:**
```
network={
    ssid="Orange_Swiatlowod_4BB0"
    psk="haslo"
    scan_ssid=1
    priority=1
}
```

**Dla hash hasła (bezpieczniej):**
```bash
# Wygeneruj hash
wpa_passphrase "Orange_Swiatlowod_4BB0" "haslo"
# Użyj wygenerowanego psk= zamiast jawnego hasła
```

### Test po wstawieniu karty:
1. Włóż kartę do BTT Pi  
2. Włącz zasilanie  
3. Poczekaj 3-4 minuty  
4. Sprawdź sieć: `nmap -sn 192.168.1.0/24`