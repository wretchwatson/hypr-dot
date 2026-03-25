#!/bin/bash

# Log dosyası oluştur
exec > /tmp/wallpaper.log 2>&1
echo "Script tetiklendi: $(date)"
echo "Gelen dosya yolu: $1"

# Check if wallpaper path is provided
if [ -z "$1" ]; then
    echo "HATA: Dosya yolu boş!"
    exit 1
fi

WALLPAPER=$1

# 1. AWWW ile duvar kağıdını ayarla
awww img "$WALLPAPER" --transition-type center --transition-step 60

# 2. Pywal ile renkleri oluştur (-n: wallpaper set etme, -q: sessiz)
wal -i "$WALLPAPER" -n -q

# Pywal renklerini yükle
source "$HOME/.cache/wal/colors.sh"

# 3. Mako'yu güncelle
if [ -f "$HOME/.config/mako/config.template" ]; then
    sed -e "s/@FOREGROUND@/$foreground/g" \
        -e "s/@BACKGROUND@/$background/g" \
        -e "s/@COLOR1@/$color1/g" \
        "$HOME/.config/mako/config.template" > "$HOME/.config/mako/config"
    makoctl reload
    notify-send -i "$WALLPAPER" "Renkler Güncellendi" "Duvar kağıdı ve temalar başarıyla yüklendi."
fi

# 4. Waybar'ı güncelle
if [ -f "$HOME/.config/waybar/style.css.template" ]; then
    sed -e "s/@FOREGROUND@/$foreground/g" \
        -e "s/@BACKGROUND@/$background/g" \
        -e "s/@COLOR1@/$color1/g" \
        -e "s/@COLOR2@/$color2/g" \
        -e "s/@COLOR3@/$color3/g" \
        -e "s/@COLOR4@/$color4/g" \
        -e "s/@COLOR5@/$color5/g" \
        -e "s/@COLOR6@/$color6/g" \
        -e "s/@COLOR7@/$color7/g" \
        -e "s/@COLOR8@/$color8/g" \
        "$HOME/.config/waybar/style.css.template" > "$HOME/.config/waybar/style.css"
fi
killall -USR2 waybar

# 5. Wofi'yi güncelle
if [ -f "$HOME/.config/wofi/style.css.template" ]; then
    sed -e "s/@FOREGROUND@/$foreground/g" \
        -e "s/@BACKGROUND@/$background/g" \
        -e "s/@COLOR0@/$color0/g" \
        -e "s/@COLOR1@/$color1/g" \
        "$HOME/.config/wofi/style.css.template" > "$HOME/.config/wofi/style.css"
fi

# 6. Wlogout'u güncelle
if [ -f "$HOME/.config/wlogout/style.css.template" ]; then
    sed -e "s/@FOREGROUND@/$foreground/g" \
        -e "s/@BACKGROUND@/$background/g" \
        -e "s/@COLOR1@/$color1/g" \
        "$HOME/.config/wlogout/style.css.template" > "$HOME/.config/wlogout/style.css"
fi

# 7. Starship'i güncelle
if [ -f "$HOME/.config/starship.toml.template" ]; then
    sed -e "s/@FOREGROUND@/$foreground/g" \
        -e "s/@BACKGROUND@/$background/g" \
        -e "s/@COLOR1@/$color1/g" \
        -e "s/@COLOR2@/$color2/g" \
        -e "s/@COLOR3@/$color3/g" \
        -e "s/@COLOR4@/$color4/g" \
        "$HOME/.config/starship.toml.template" > "$HOME/.config/starship.toml"
fi

# 8. QT6CT'yi güncelle
if [ -f "$HOME/.cache/wal/colors-qt6ct.conf" ]; then
    mkdir -p "$HOME/.config/qt6ct/colors"
    cp "$HOME/.cache/wal/colors-qt6ct.conf" "$HOME/.config/qt6ct/colors/Pywal.conf"
fi

# 9. Kitty'ye duyur
killall -USR1 kitty 2>/dev/null

# 10. Hyprlock'u güncelle
if [ -f "$HOME/.config/hypr/hyprlock.conf" ]; then
    sed -i "s|path = .*|path = $WALLPAPER|" "$HOME/.config/hypr/hyprlock.conf"
fi

echo "İşlem başarıyla tamamlandı!"
