# Flashowanie obrazu CB1 na Ubuntu Linux

## Problem z flashowaniem na macOS/Windows
Obrazy CB1 mogą mieć problemy gdy są flashowane na systemach innych niż Linux z powodu:
- Różnej obsługi systemów plików Linux
- Problemów z prawami dostępu
- Niepoprawnego kopiowania metadanych

## Zalecane narzędzia na Ubuntu:

### 1. DD (najpoprawniejsze)
```bash
# Sprawdź urządzenie
lsblk
sudo fdisk -l

# Flashowanie (UWAGA: sprawdź dokładnie /dev/sdX!)
sudo dd if=CB1_Debian12_Klipper_kernel6.6_20241219.img of=/dev/sdX bs=4M status=progress
sudo sync
```

### 2. Raspberry Pi Imager (Linux version)
```bash
# Instalacja
sudo apt update
sudo apt install rpi-imager

# Uruchomienie
rpi-imager
```

### 3. Balena Etcher (Linux)
```bash
# Pobierz .AppImage z:
# https://github.com/balena-io/etcher/releases

chmod +x balenaEtcher-*.AppImage
./balenaEtcher-*.AppImage
```

### 4. GNOME Disks (GUI)
```bash
sudo apt install gnome-disk-utility
gnome-disks
# Wybierz dysk → "Restore Disk Image"
```

## Zalecenia:

### Przed flashowaniem:
```bash
# Sprawdź sumę kontrolną obrazu
sha256sum CB1_Debian12_Klipper_kernel6.6_20241219.img

# Porównaj z oficjalną sumą z GitHub releases
```

### Po flashowaniu:
```bash
# Sprawdź partycje
sudo parted /dev/sdX print

# Sprawdź systemy plików
sudo fsck /dev/sdX1
sudo fsck /dev/sdX2
```

### Dostęp do partycji boot (ext4):
```bash
# Montowanie partycji boot
sudo mkdir /mnt/cb1-boot
sudo mount /dev/sdX1 /mnt/cb1-boot

# Edycja plików konfiguracyjnych
sudo nano /mnt/cb1-boot/BoardEnv.txt
sudo nano /mnt/cb1-boot/network.txt

# Odmontowanie
sudo umount /mnt/cb1-boot
```

## Konfiguracja Wi-Fi na Ubuntu:

### W partycji boot CB1:
```bash
# /mnt/cb1-boot/network.txt lub similar
WIFI_SSID="nazwa_sieci"
WIFI_PASS="haslo_wifi"
WIFI_COUNTRY="PL"
```

### Lub w wpa_supplicant:
```bash
# /mnt/cb1-boot/wpa_supplicant.conf
country=PL
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="nazwa_sieci"
    psk="haslo"
    key_mgmt=WPA-PSK
}
```

## Troubleshooting Ubuntu:

### Problemy z kartą SD:
```bash
# Sprawdzenie błędów karty
sudo badblocks -v /dev/sdX

# Formatowanie przed flashowaniem
sudo wipefs -a /dev/sdX
sudo parted /dev/sdX mklabel msdos
```

### Test karty SD:
```bash
# Test prędkości zapisu/odczytu
sudo hdparm -tT /dev/sdX

# Test na błędy
sudo e2fsck -f /dev/sdX2
```

## Korzyści Ubuntu vs macOS/Windows:

1. **Pełny dostęp** do wszystkich partycji Linux
2. **Natywne narzędzia** (dd, parted, fsck)
3. **Poprawne kopiowanie** metadata i permissions
4. **Możliwość edycji** plików konfiguracyjnych przed uruchomieniem
5. **Lepsza diagnostyka** problemów z kartą SD

## Po flashowaniu na Ubuntu:
- Sprawdź czy wszystkie partycje są poprawne
- Skonfiguruj Wi-Fi w odpowiednich plikach
- Test karty SD przed włożeniem do BTT Pi