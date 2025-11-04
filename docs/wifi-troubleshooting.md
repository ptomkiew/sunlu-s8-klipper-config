# Rozwiązywanie problemów Wi-Fi z BTT Pi

## Możliwe przyczyny braku połączenia:

### 1. **Problem z hasłem Wi-Fi**
- Sprawdź czy hasło zawiera znaki specjalne
- Upewnij się, że nie ma polskich znaków
- Hasło powinno być w cudzysłowach

### 2. **Problem z kodowaniem kraju**
- Sprawdź czy "PL" jest poprawne dla twojego regionu
- Niektóre routery wymagają "EU" zamiast "PL"

### 3. **Kompatybilność z siecią 2.4GHz**
- BTT Pi obsługuje tylko 2.4GHz
- Sprawdź czy router nadaje na tej częstotliwości
- Może być konieczne oddzielenie sieci 2.4GHz od 5GHz

### 4. **Filtrowanie MAC**
- Sprawdź czy router ma włączone filtrowanie MAC
- Dodaj MAC BTT Pi do listy dozwolonych

## Kroki diagnostyczne:

### A. Sprawdź kartę SD ponownie:
```bash
# Włóż kartę SD do Maca i sprawdź pliki
ls -la /Volumes/bootfs/
cat /Volumes/bootfs/firstrun.sh
```

### B. Sprawdź logi routera:
1. Wejdź do http://192.168.1.1
2. Szukaj sekcji "System Log" lub "Connection Log"
3. Sprawdź czy pojawiają się próby połączenia

### C. Test z hotspotem mobilnym:
1. Utwórz hotspot na telefonie
2. Nazwa: "TestBTT" (bez polskich znaków)
3. Hasło: "12345678" (proste hasło)
4. Przeprogramuj kartę SD z tymi danymi

## Następne kroki:
1. **Priorytet**: Test kabel Ethernet
2. **Backup**: Hotspot mobilny
3. **Diagnoza**: Sprawdzenie logów routera