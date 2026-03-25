#!/bin/bash

ANIM_DIR="$HOME/.config/hypr/animations"
DEST_FILE="$HOME/.config/hypr/config/animations.conf"
STATE_FILE="/tmp/current_hypr_anim"

# Animasyon dosyalarını listeye al (alfabetik)
files=($(find "$ANIM_DIR" -maxdepth 1 -name "*.conf" | sort))
total=${#files[@]}

if [ $total -eq 0 ]; then
    notify-send -u critical "Hata" "Animasyon klasörü boş veya bulunamadı!"
    exit 1
fi

# Mevcut ayarı oku
current_idx=-1
if [ -f "$STATE_FILE" ]; then
    current_idx=$(cat "$STATE_FILE")
fi

# Sonraki animasyona geç
next_idx=$(( (current_idx + 1) % total ))

# Yeni durumu kaydet
echo "$next_idx" > "$STATE_FILE"

# Seçilen dosyayı ayarla
selected_file="${files[$next_idx]}"
file_name=$(basename "$selected_file" .conf)

# Eski dosyayı kopyala (hyprland dosyayı görünce kendiliğinden reload atar)
cp "$selected_file" "$DEST_FILE"

# Ayrıca yine de reload yapalım ne olur ne olmaz
hyprctl reload >/dev/null 2>&1

# Bildirimi (mako ile) gönder
notify-send -t 2000 "✨ Animasyon Değiştirildi" "Yeni Profil: <b>$file_name</b>"
