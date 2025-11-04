# Instrukcje instalacji BTT Pi v1.2.1 z Klipperem

## Wymagania
- BTT Pi v1.2.1
- BTT SKR 3 EZ
- Karta microSD (min. 16GB, Class 10)
- Kabel USB-C dla zasilania BTT Pi
- Przewody połączeniowe

## Krok 1: Przygotowanie karty SD

1. Pobierz obraz Raspberry Pi OS Lite (64-bit) ze strony oficjalnej
2. Użyj Raspberry Pi Imager do wgrania obrazu na kartę SD
3. Włącz SSH i skonfiguruj Wi-Fi przed pierwszym uruchomieniem

## Krok 2: Pierwszy rozruch BTT Pi

1. Włóż kartę SD do BTT Pi
2. Podłącz zasilanie USB-C
3. Poczekaj na pełny rozruch (około 2-3 minuty)
4. Znajdź adres IP BTT Pi w routerze lub użyj nmap

## Krok 3: Aktualizacja systemu

```bash
sudo apt update && sudo apt upgrade -y
sudo reboot
```

## Krok 4: Instalacja Klippera

```bash
cd ~
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

## Krok 5: Instalacja Mainsail

```bash
cd ~
git clone https://github.com/mainsail-crew/mainsail-config.git
ln -sf ~/mainsail-config/client.cfg ~/printer_data/config/mainsail.cfg
```

## Krok 6: Kompilacja firmware dla SKR 3 EZ

1. Konfiguracja kompilacji:
```bash
cd ~/klipper
make menuconfig
```

Ustawienia dla STM32H743:
- Micro-controller: STMicroelectronics STM32
- Processor model: STM32H743
- Bootloader offset: 128KiB bootloader
- Clock Reference: 25 MHz crystal
- Communication interface: USB (on PA11/PA12)

2. Kompilacja:
```bash
make clean
make
```

3. Skopiuj plik `klipper.bin` na kartę SD i wgraj do SKR 3 EZ

## Krok 7: Konfiguracja połączenia

1. Podłącz SKR 3 EZ do BTT Pi przez USB
2. Sprawdź port serial:
```bash
ls /dev/serial/by-id/
```

3. Skopiuj plik konfiguracyjny:
```bash
cp ~/skr3ez-setup/klipper/printer.cfg ~/printer_data/config/
```

## Krok 8: Restart usług

```bash
sudo systemctl restart klipper
sudo systemctl restart nginx
```

## Krok 9: Dostęp do interfejsu

Otwórz przeglądarkę i przejdź do adresu IP BTT Pi.
Powinieneś zobaczyć interfejs Mainsail.