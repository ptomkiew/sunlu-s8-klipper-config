# Konfiguracja TFT35 SPI dla BTT Pi v1.2.1

## Problem: Biały ekran TFT35 SPI

**Przyczyna:** Brak konfiguracji sterownika SPI w systemie CB1.

## Schemat połączeń J5 (TFT35 SPI):

```
BTT Pi J5          TFT35 SPI
─────────────────  ─────────────
Pin 1  - 3.3V   →  VCC
Pin 2  - GND    →  GND  
Pin 3  - MOSI   →  SDA (MOSI)
Pin 4  - SCK    →  SCL (SCK)
Pin 5  - CS     →  CS
Pin 6  - DC     →  DC/RS
Pin 7  - RESET  →  RST
Pin 8  - BL     →  LED (podświetlenie)
```

## Konfiguracja w systemie CB1:

### 1. Plik /boot/config.txt
Dodaj konfigurację SPI i TFT:

```
# Włączenie SPI
dtparam=spi=on

# TFT35 SPI Display
dtoverlay=tft35a
dtparam=rotate=90
dtparam=speed=16000000
dtparam=fps=25

# Framebuffer
dtoverlay=rpi-display
dtparam=rotate=270
```

### 2. Alternatywna konfiguracja dla ili9488:

```
# Włączenie SPI
dtparam=spi=on

# TFT35 z chipem ili9488
dtoverlay=rpi-display,rotate=90
dtparam=speed=16000000
```

### 3. Konfiguracja dla X11/framebuffer:

```
# W /etc/X11/xorg.conf.d/99-fbdev.conf
Section "Device"  
    Identifier "TFT LCD"
    Driver "fbdev"
    Option "fbdev" "/dev/fb1"
EndSection
```

## Sterowniki dla różnych chipów TFT35:

### ILI9488 (najczęstszy):
```bash
# Instalacja sterownika
sudo apt update
sudo apt install -y python3-pip
pip3 install adafruit-circuitpython-ili9488
```

### ST7796 (alternatywny):
```bash
# Konfiguracja w device tree
dtoverlay=rpi-display,rotate=90
dtparam=speed=16000000
```

## Konfiguracja Klipper dla TFT35:

### W printer.cfg dodaj sekcję display:

```
[display]
lcd_type: st7920
cs_pin: rpi:None
sclk_pin: rpi:gpio11
sid_pin: rpi:gpio10
encoder_pins: ^rpi:gpio25, ^rpi:gpio24
click_pin: ^!rpi:gpio23

[output_pin beeper]
pin: rpi:gpio18
pwm: True
value: 0
shutdown_value: 0
cycle_time: 0.001
scale: 1000
```

## Troubleshooting TFT35:

### Sprawdzenie SPI:
```bash
# Sprawdź czy SPI jest włączone
lsmod | grep spi

# Lista urządzeń SPI
ls /dev/spi*

# Test framebuffer
ls /dev/fb*
```

### Test wyświetlania:
```bash
# Test kolorów
sudo fbi -T 1 -d /dev/fb1 test.png

# Sprawdzenie rozdzielczości
fbset -fb /dev/fb1
```

### Konfiguracja podświetlenia:
```bash
# Włączenie podświetlenia
echo 1 > /sys/class/backlight/rpi_backlight/bl_power
echo 255 > /sys/class/backlight/rpi_backlight/brightness
```

## Instalacja sterowników (po SSH):

### 1. Aktualizacja systemu:
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalacja pakietów TFT:
```bash
sudo apt install -y python3-dev python3-pip
sudo apt install -y libfreetype6-dev libjpeg-dev
pip3 install luma.lcd luma.oled
```

### 3. Konfiguracja autostart:
```bash
# Dodanie do /etc/rc.local
/usr/bin/python3 /home/pi/tft35_init.py &
```

## Skrypt inicjalizacji TFT35:

```python
#!/usr/bin/env python3
# /home/pi/tft35_init.py

import spidev
import RPi.GPIO as GPIO
import time

# Konfiguracja pinów
CS_PIN = 8
DC_PIN = 24
RST_PIN = 25
BL_PIN = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(CS_PIN, GPIO.OUT)
GPIO.setup(DC_PIN, GPIO.OUT)  
GPIO.setup(RST_PIN, GPIO.OUT)
GPIO.setup(BL_PIN, GPIO.OUT)

# Reset TFT
GPIO.output(RST_PIN, 0)
time.sleep(0.1)
GPIO.output(RST_PIN, 1)
time.sleep(0.1)

# Włączenie podświetlenia
GPIO.output(BL_PIN, 1)

print("TFT35 zainicjalizowany")
```

## Następne kroki:

1. **Najpierw nawiąż połączenie SSH** z BTT Pi
2. **Sprawdź czy system CB1 się uruchomił** 
3. **Skonfiguruj SPI i sterowniki TFT**
4. **Test wyświetlacza**

**Priorytet: Najpierw połącz się z BTT Pi przez SSH, potem skonfigurujemy TFT35!**