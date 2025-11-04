# Test połączenia Ethernet z BTT Pi

## Krok po kroku:

1. **Podłącz kabel Ethernet** między BTT Pi a routerem
2. **Przeładuj BTT Pi** (odłącz i podłącz zasilanie)
3. **Poczekaj 2-3 minuty** na pełny boot
4. **Sprawdź urządzenia w sieci:**
   ```bash
   nmap -sn 192.168.1.0/24
   ```

## Zalety połączenia Ethernet:
- ✅ Niezawodne połączenie
- ✅ Szybsza konfiguracja
- ✅ Brak problemów z Wi-Fi
- ✅ Stabilność połączenia

## Po nawiązaniu połączenia Ethernet:
1. Można skonfigurować Wi-Fi przez SSH
2. Sprawdzić logi systemowe
3. Kontynuować instalację Klippera