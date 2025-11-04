# Zworki i przełączniki BTT Pi v1.2.1

## J8 - Boot Mode Jumper (Zworka trybu uruchamiania)

### Pozycje zworki J8:
- **Brak zworki / otwarte**: Normalny boot z karty SD
- **Zworka założona**: FEL Mode (tryb programowania/recovery)

### FEL Mode - do czego służy:
1. **Recovery systemu** - gdy karta SD nie bootuje
2. **Programowanie bezpośrednie** przez USB
3. **Diagnostyka hardware** - gdy system się nie uruchamia
4. **Instalacja bootloadera** - w przypadku uszkodzenia

### Kiedy używać FEL Mode:
- System nie bootuje z karty SD
- Nieskończona pętla bootowania
- Uszkodzony bootloader
- Diagnostyka sprzętowa

## Inne ważne zworki na BTT Pi:

### J9 - Power Selection
- **5V_EXT**: Zasilanie z zewnętrznego źródła 5V
- **USB_5V**: Zasilanie z portu USB (domyślne)

### J10 - GPIO Power
- **3.3V**: GPIO na napięciu 3.3V (domyślne, bezpieczne)
- **5V**: GPIO na napięciu 5V (tylko dla specjalnych zastosowań)

## Procedura używania FEL Mode (J8):

### 1. Wejście do FEL Mode:
```bash
# 1. Wyłącz BTT Pi
# 2. Załóż zworkę J8
# 3. Podłącz kabel USB do komputera
# 4. Włącz BTT Pi
# 5. BTT Pi uruchomi się w trybie FEL
```

### 2. Sprawdzenie FEL Mode (Linux/macOS):
```bash
# Sprawdź czy urządzenie jest w trybie FEL
lsusb | grep "1f3a:efe8"  # Allwinner FEL device
```

### 3. Wyjście z FEL Mode:
```bash
# 1. Wyłącz BTT Pi
# 2. Usuń zworkę J8
# 3. Włącz BTT Pi normalnie
```

## Diagnostyka z FEL Mode:

### Sunxi-fel tools (dla Linux/macOS):
```bash
# Instalacja narzędzi
brew install sunxi-tools  # macOS
# lub
sudo apt install sunxi-tools  # Linux

# Sprawdzenie urządzenia
sunxi-fel version

# Informacje o SoC
sunxi-fel sid
```

## 🚨 ROZWIĄZANIE PROBLEMU BOOTOWANIA:

Jeśli BTT Pi nie bootuje poprawnie:

### 1. Test FEL Mode:
- Załóż zworkę J8
- Podłącz USB do komputera
- Sprawdź czy urządzenie jest wykrywane

### 2. Jeśli FEL działa:
- Problem z kartą SD lub obrazem systemu
- Przeprogramuj kartę SD
- Sprawdź partycje

### 3. Jeśli FEL nie działa:
- Problem sprzętowy z BTT Pi
- Sprawdź zasilanie
- Sprawdź inne zworki

## Obecnie dla Twojego problemu:

**Spróbuj FEL Mode test:**
1. Wyłącz BTT Pi
2. Załóż zworkę J8 (krótki przewód/zworka)
3. Podłącz kabel USB-C do komputera (nie do ładowarki)
4. Sprawdź czy macOS wykrywa nowe urządzenie

To pomoże określić czy BTT Pi w ogóle się uruchamia!