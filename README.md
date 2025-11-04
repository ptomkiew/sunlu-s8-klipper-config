# BTT Pi v1.2.1 + Klipper + SKR 3 EZ - Kompletna konfiguracja

![BTT Pi](https://img.shields.io/badge/BTT_Pi-v1.2.1-orange)
![Klipper](https://img.shields.io/badge/Klipper-3D_Printer-blue)
![SKR 3 EZ](https://img.shields.io/badge/SKR_3_EZ-Mainboard-green)

## 🎯 Cel projektu

Ten projekt zawiera kompletną konfigurację do uruchomienia modułu **BTT Pi v1.2.1** z systemem **Klipper** i płytą główną **BTT SKR 3 EZ** dla drukarek 3D.

## 📁 Struktura projektu

```
skr3ez-setup/
├── .github/
│   └── copilot-instructions.md    # Instrukcje dla GitHub Copilot
├── .vscode/
│   └── tasks.json                 # Zadania VS Code
├── btt-pi/
│   └── konfiguracja.md           # Konfiguracja BTT Pi
├── docs/
│   ├── instrukcje-instalacji.md  # Szczegółowe instrukcje
│   └── przewodnik-uruchomienia.md # Krok po kroku uruchomienie
├── firmware/                     # Miejsce na pliki firmware
├── klipper/
│   └── printer.cfg               # Konfiguracja Klippera dla SKR 3 EZ
├── scripts/
│   ├── install-klipper.sh        # Automatyczna instalacja Klippera
│   └── compile-firmware.sh       # Kompilacja firmware
└── README.md                     # Ten plik
```

## 🚀 Szybki start

### Wymagania
- BTT Pi v1.2.1
- BTT SKR 3 EZ
- Karta microSD (min. 16GB)
- Zasilacz USB-C 5V/3A dla BTT Pi
- Zasilacz 12V/24V dla SKR 3 EZ

### Instalacja w 3 krokach

1. **Przygotuj kartę SD z Raspberry Pi OS**
2. **Uruchom automatyczną instalację Klippera**
3. **Skompiluj i wgraj firmware do SKR 3 EZ**

Szczegółowe instrukcje znajdziesz w [Przewodniku uruchomienia](docs/przewodnik-uruchomienia.md).

## 🛠️ Funkcje VS Code

Ten projekt zawiera gotowe zadania VS Code do zarządzania instalacją:

- **Instalacja Klippera na BTT Pi** - automatyczna instalacja
- **Kompilacja firmware SKR 3 EZ** - budowanie firmware
- **Sprawdź status Klippera** - diagnostyka
- **Restart Klippera** - restart usługi
- **Sprawdź porty serial** - wykrywanie SKR 3 EZ

### Uruchomienie zadań
1. Naciśnij `Ctrl+Shift+P`
2. Wpisz "Tasks: Run Task"
3. Wybierz odpowiednie zadanie

## 📋 Konfiguracja sprzętu

### BTT Pi v1.2.1
- **CPU**: Allwinner H3 Quad-Core ARM Cortex-A7
- **RAM**: 1GB DDR3
- **Łączność**: Wi-Fi 2.4GHz, Ethernet 100Mbps
- **USB**: 2x USB 2.0, 1x USB-C (zasilanie)

### BTT SKR 3 EZ
- **MCU**: STM32H743VGT6 32-bit ARM Cortex-M7
- **Stepper drivers**: TMC2209 (UART)
- **Złącza**: 4x stepper, heated bed, hot end, fans
- **Komunikacja**: USB-C, CAN bus (opcjonalnie)

### Schemat połączeń
```
BTT Pi v1.2.1  ←→  BTT SKR 3 EZ
USB-A              USB-C (komunikacja)
USB-C (5V/3A)      12V/24V (zasilanie)
```

## 📖 Dokumentacja

- 📚 [Instrukcje instalacji](docs/instrukcje-instalacji.md) - szczegółowy proces instalacji
- 🚀 [Przewodnik uruchomienia](docs/przewodnik-uruchomienia.md) - krok po kroku
- ⚙️ [Konfiguracja BTT Pi](btt-pi/konfiguracja.md) - ustawienia sprzętowe
- 🖨️ [Konfiguracja Klippera](klipper/printer.cfg) - ustawienia drukarki

## 🔧 Zaawansowana konfiguracja

### Sieć
```bash
# Wi-Fi
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

# Statyczny IP
sudo nano /etc/dhcpcd.conf
```

### Optymalizacja
```bash
# Zwiększenie swap dla kompilacji
sudo dphys-swapfile swapoff
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=512/' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

## 🐛 Rozwiązywanie problemów

### Typowe problemy

| Problem | Rozwiązanie |
|---------|------------|
| BTT Pi nie uruchamia się | Sprawdź zasilanie 5V/3A i kartę SD |
| Brak połączenia z SKR 3 EZ | Sprawdź kabel USB i wgrany firmware |
| Klipper nie startuje | Sprawdź konfigurację serial w printer.cfg |
| Brak dostępu do Mainsail | Sprawdź nginx i adres IP |

### Diagnostyka
```bash
# Status usług
sudo systemctl status klipper
sudo systemctl status nginx
sudo systemctl status moonraker

# Logi w czasie rzeczywistym
journalctl -u klipper -f

# Porty serial
ls /dev/serial/by-id/
```

## 🌐 Dostęp do interfejsu

Po pomyślnej instalacji:
- **Mainsail**: `http://IP_ADRES_BTT_PI`
- **SSH**: `ssh pi@IP_ADRES_BTT_PI`

## 📝 Licencja

Ten projekt jest udostępniony na licencji MIT. Zobacz plik LICENSE dla szczegółów.

## 🤝 Wsparcie

Jeśli napotkasz problemy:
1. Sprawdź [dokumentację](docs/)
2. Sprawdź [issues](https://github.com/twoj-repo/skr3ez-setup/issues)
3. Utwórz nowy issue z opisem problemu

## 🔄 Aktualizacje

### v1.0.0 (28 października 2025)
- ✅ Pierwsza wersja konfiguracji
- ✅ Automatyczne skrypty instalacji
- ✅ Zadania VS Code
- ✅ Kompletna dokumentacja

---

**Zbudowano z ❤️ dla społeczności druku 3D**