#!/bin/bash

echo "=== Kompilacja firmware dla BTT SKR 3 EZ (UART) ==="

# Sprawdź czy istnieje katalog klipper
if [ ! -d "/tmp/klipper" ]; then
    echo "Klonowanie repozytorium Klipper..."
    cd /tmp
    git clone https://github.com/Klipper3d/klipper.git
    cd klipper
else
    echo "Katalog Klipper już istnieje, aktualizowanie..."
    cd /tmp/klipper
    git pull
fi

# Konfiguracja dla STM32H743 z UART
echo "Konfigurowanie dla STM32H743 z komunikacją UART..."
make clean

# Automatyczna konfiguracja - UART zamiast USB
echo "CONFIG_MACH_STM32=y
CONFIG_MACH_STM32H743=y
CONFIG_MCU=\"stm32h743xx\"
CONFIG_CLOCK_FREQ=400000000
CONFIG_SERIAL=y
CONFIG_STM32_SERIAL_USART1=y
CONFIG_SERIAL_BAUD=250000
CONFIG_STM32_FLASH_START_8000=y
CONFIG_STM32_CLOCK_REF_25M=y
CONFIG_STM32_APPLICATION_ADC=y" > .config

echo "Kompilacja firmware z obsługą UART..."
make -j$(nproc)

if [ $? -eq 0 ]; then
    echo "=== SUKCES ==="
    echo "Firmware UART skompilowany: out/klipper.bin"
    echo ""
    echo "INSTRUKCJE WGRYWANIA:"
    echo "1. Skopiuj plik out/klipper.bin na kartę SD jako 'firmware.bin'"
    echo "2. Włóż kartę SD do SKR 3 EZ"
    echo "3. Zresetuj SKR 3 EZ lub włącz zasilanie"
    echo "4. Plik zostanie automatycznie wgrany i przemianowany na firmware.cur"
    echo ""
    echo "POŁĄCZENIE UART:"
    echo "BTT Pi GPIO14 (TX) -> SKR 3 EZ PA10 (RX)"
    echo "BTT Pi GPIO15 (RX) -> SKR 3 EZ PA9 (TX)"
    echo "GND -> GND"
    echo ""
    ls -la out/klipper.bin
    
    # Kopiuj do katalogu firmware
    cp out/klipper.bin "../skr3ez setup/firmware/firmware_skr3ez_uart.bin"
    echo "Firmware UART skopiowany do: firmware/firmware_skr3ez_uart.bin"
else
    echo "=== BŁĄD KOMPILACJI ==="
    exit 1
fi