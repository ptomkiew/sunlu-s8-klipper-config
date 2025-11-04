#!/bin/bash

# Skrypt automatycznej instalacji Klippera na BTT Pi v1.2.1
# Data: 28 października 2025

echo "🚀 Rozpoczynam instalację Klippera na BTT Pi v1.2.1..."

# Aktualizacja systemu
echo "📦 Aktualizacja systemu..."
sudo apt update && sudo apt upgrade -y

# Instalacja niezbędnych pakietów
echo "📦 Instalacja niezbędnych pakietów..."
sudo apt install -y git python3-virtualenv python3-dev libffi-dev build-essential \
    libncurses-dev libusb-dev avrdude gcc-avr binutils-avr avr-libc \
    stm32flash libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi \
    libusb-1.0-0-dev pkg-config

# Klonowanie repozytorium Klippera
echo "📥 Pobieranie Klippera..."
cd ~ || exit
if [ -d "klipper" ]; then
    echo "Klipper już istnieje, aktualizuję..."
    cd klipper || exit
    git pull
else
    git clone https://github.com/Klipper3d/klipper
fi

# Instalacja Klippera
echo "🔧 Instalacja Klippera..."
cd ~/klipper || exit
./scripts/install-octopi.sh

# Instalacja Mainsail
echo "🌐 Instalacja Mainsail..."
cd ~ || exit
if [ -d "mainsail-config" ]; then
    echo "Mainsail config już istnieje, aktualizuję..."
    cd mainsail-config || exit
    git pull
else
    git clone https://github.com/mainsail-crew/mainsail-config.git
fi

# Konfiguracja Mainsail
mkdir -p ~/printer_data/config
ln -sf ~/mainsail-config/client.cfg ~/printer_data/config/mainsail.cfg

# Pobieranie najnowszego Mainsail
cd ~ || exit
wget -q -O mainsail.zip https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip
unzip -o mainsail.zip -d ~/mainsail
rm mainsail.zip

# Konfiguracja nginx
sudo tee /etc/nginx/sites-available/mainsail <<EOF
server {
    listen 80 default_server;
    
    access_log /var/log/nginx/mainsail-access.log;
    error_log /var/log/nginx/mainsail-error.log;

    # disable this section on smaller hardware like a pi zero
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_proxied expired no-cache no-store private auth;
    gzip_comp_level 4;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;

    # web_path from mainsail static files
    root ~/mainsail;

    index index.html;
    server_name _;

    # disable max upload size checks
    client_max_body_size 0;

    # disable proxy request buffering
    proxy_request_buffering off;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location = /index.html {
        add_header Cache-Control "no-store, no-cache, must-revalidate";
    }

    location /websocket {
        proxy_pass http://apiserver/websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_read_timeout 86400;
    }

    location ~ ^/(printer|api|access|machine|server)/ {
        proxy_pass http://apiserver\$request_uri;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme \$scheme;
    }

    location /webcam/ {
        proxy_pass http://mjpgstreamer1/;
    }

    location /webcam2/ {
        proxy_pass http://mjpgstreamer2/;
    }

    location /webcam3/ {
        proxy_pass http://mjpgstreamer3/;
    }

    location /webcam4/ {
        proxy_pass http://mjpgstreamer4/;
    }
}

upstream apiserver {
    ip_hash;
    server 127.0.0.1:7125;
}

upstream mjpgstreamer1 {
    ip_hash;
    server 127.0.0.1:8080;
}

upstream mjpgstreamer2 {
    ip_hash;
    server 127.0.0.1:8081;
}

upstream mjpgstreamer3 {
    ip_hash;
    server 127.0.0.1:8082;
}

upstream mjpgstreamer4 {
    ip_hash;
    server 127.0.0.1:8083;
}
EOF

# Aktywacja konfiguracji nginx
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/mainsail /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Restart usług
echo "🔄 Restart usług..."
sudo systemctl restart klipper
sudo systemctl restart nginx

echo "✅ Instalacja zakończona!"
echo "🌐 Mainsail dostępny pod adresem: http://$(hostname -I | awk '{print $1}')"
echo ""
echo "Następne kroki:"
echo "1. Skompiluj firmware dla SKR 3 EZ (make menuconfig && make)"
echo "2. Skopiuj klipper.bin na kartę SD i wgraj do SKR 3 EZ"
echo "3. Podłącz SKR 3 EZ przez USB do BTT Pi"
echo "4. Skopiuj printer.cfg do ~/printer_data/config/"
echo "5. Restart Klippera: sudo systemctl restart klipper"