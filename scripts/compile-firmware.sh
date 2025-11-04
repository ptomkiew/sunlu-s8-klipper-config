#!/bin/bash

# Skrypt kompilacji firmware dla BTT SKR 3 EZ
# Data: 28 października 2025

echo "🔧 Kompilacja firmware dla BTT SKR 3 EZ..."

cd ~/klipper || exit

# Sprawdzenie czy Klipper jest zainstalowany
if [ ! -d ~/klipper ]; then
    echo "❌ Klipper nie jest zainstalowany. Uruchom najpierw install-klipper.sh"
    exit 1
fi

echo "📝 Konfiguracja kompilacji..."

# Automatyczna konfiguracja
cat > .config <<EOF
CONFIG_LOW_LEVEL_OPTIONS=y
CONFIG_MACH_STM32=y
CONFIG_MACH_STM32H7=y
CONFIG_MACH_STM32H743=y
CONFIG_CLOCK_FREQ_25000000=y
CONFIG_STM32_FLASH_START_20000=y
CONFIG_USBSERIAL=y
CONFIG_USB_VENDOR_ID=0x1d50
CONFIG_USB_DEVICE_ID=0x614e
CONFIG_USB_SERIAL_NUMBER_CHIPID=y
CONFIG_WANT_GPIO_BITBANGING=y
CONFIG_WANT_DISPLAYS=y
CONFIG_WANT_SENSORS=y
CONFIG_WANT_LIS2DW=y
CONFIG_WANT_LDC1612=y
CONFIG_WANT_HX71X=y
CONFIG_WANT_ADS1220=y
CONFIG_WANT_SOFTWARE_I2C=y
CONFIG_WANT_SOFTWARE_SPI=y
CONFIG_NEED_SENSOR_BULK=y
CONFIG_CANBUS_FREQUENCY=1000000
CONFIG_INITIAL_PINS=""
CONFIG_HAVE_GPIO=y
CONFIG_HAVE_GPIO_ADC=y
CONFIG_HAVE_GPIO_SPI=y
CONFIG_HAVE_GPIO_I2C=y
CONFIG_HAVE_GPIO_HARD_PWM=y
CONFIG_HAVE_GPIO_BITBANGING=y
CONFIG_HAVE_STRICT_TIMING=y
CONFIG_HAVE_CHIPID=y
CONFIG_INLINE_STEPPER_HACK=y
EOF

echo "🔨 Kompilacja..."
make clean
make -j"$(nproc)"

if [ $? -eq 0 ]; then
    echo "✅ Kompilacja zakończona pomyślnie!"
    echo "📁 Firmware znajduje się w: ~/klipper/out/klipper.bin"
    echo ""
    echo "Następne kroki:"
    echo "1. Skopiuj out/klipper.bin na kartę SD jako firmware.bin"
    echo "2. Włóż kartę do SKR 3 EZ i uruchom płytę"
    echo "3. Plik firmware.bin zostanie automatycznie wgrany"
    echo "4. Po wgraniu plik zmieni nazwę na firmware.cur"
else
    echo "❌ Błąd kompilacji!"
    exit 1
fi