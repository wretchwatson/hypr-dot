#!/bin/bash

# Hyprland Dotfiles Kurulum Scripti
# Hazırlayan: Antigravity

echo "🚀 Hyprland kurulumu başlıyor..."

# 1. Native Paketleri Kur
if [ -f "pkglist.txt" ]; then
    echo "📦 Native paketler kuruluyor..."
    if ! sudo pacman -S --needed - < pkglist.txt; then
        echo "❌ Native paket kurulumu sırasında hatalar/çakışmalar oluştu! Lütfen yukarıdaki çıktıları kontrol edin."
        read -p "Devam etmek istiyor musunuz? (y/n): " choice
        case "$choice" in 
          y|Y ) echo "Devam ediliyor...";;
          * ) echo "Kurulum durduruldu."; exit 1;;
        esac
    fi
else
    echo "⚠️ pkglist.txt bulunamadı, atlanıyor."
fi

# 2. AUR Paketlerini Kur (paru kontrolü ve kurulumu)
if [ -f "aurlist.txt" ]; then
    echo "📦 AUR paketleri kontrol ediliyor..."
    if ! command -v paru >/dev/null 2>&1; then
        echo "🤔 paru bulunamadı. paru'yu otomatik olarak kurmak ister misiniz? (y/n)"
        read -r install_paru
        if [[ "$install_paru" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "🛠️ paru kuruluyor..."
            sudo pacman -S --needed --noconfirm base-devel git
            git clone https://aur.archlinux.org/paru.git /tmp/paru-install
            cd /tmp/paru-install
            makepkg -si --noconfirm
            cd -
            rm -rf /tmp/paru-install
        else
            echo "❌ paru kurulumu reddedildi. AUR paketleri atlanıyor."
        fi
    fi

    if command -v paru >/dev/null 2>&1; then
        echo "📦 AUR paketleri kuruluyor..."
        if ! paru -S --needed - < aurlist.txt; then
            echo "❌ AUR paket kurulumu sırasında hatalar/çakışmalar oluştu!"
            read -p "Devam etmek istiyor musunuz? (y/n): " choice
            case "$choice" in 
              y|Y ) echo "Devam ediliyor...";;
              * ) echo "Kurulum durduruldu."; exit 1;;
            esac
        fi
    fi
else
    echo "⚠️ aurlist.txt bulunamadı, atlanıyor."
fi

# 3. Dosyaları Yerine Kopyala
echo "📂 Yapılandırma dosyaları kopyalanıyor..."

# .config
if [ -d ".config" ]; then
    mkdir -p ~/.config
    cp -rv .config/* ~/.config/
fi

# .icons
if [ -d ".icons" ]; then
    mkdir -p ~/.icons
    cp -rv .icons/* ~/.icons/
fi

# .bashrc
if [ -f ".bashrc" ]; then
    cp -v .bashrc ~/.bashrc
fi

# Wallpapers
if [ -d ".local/share/wallpapers" ]; then
    mkdir -p ~/.local/share/wallpapers
    cp -rv .local/share/wallpapers/* ~/.local/share/wallpapers/
fi

# Systemd coredump (sudo gerekir)
if [ -f "etc/systemd/coredump.conf.d/99-antigravity.conf" ]; then
    echo "🛡️ Systemd coredump ayarı kopyalanıyor..."
    sudo mkdir -p /etc/systemd/coredump.conf.d
    sudo cp -v etc/systemd/coredump.conf.d/99-antigravity.conf /etc/systemd/coredump.conf.d/
fi

# Greetd config (sudo gerekir)
if [ -f "etc/greetd/config.toml" ]; then
    echo "🛡️ Greetd yapılandırması kopyalanıyor..."
    sudo mkdir -p /etc/greetd
    sudo cp -v etc/greetd/config.toml /etc/greetd/config.toml
    
    echo "🔔 Greetd servisini aktif etmek ister misiniz? (y/n)"
    read -r enable_greetd
    if [[ "$enable_greetd" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "🔄 Diğer display managerlar kontrol ediliyor..."
        for dm in sddm gdm lightdm ly; do
            if systemctl is-active --quiet $dm.service; then
                echo "🛑 $dm servisi durduruluyor ve devre dışı bırakılıyor..."
                sudo systemctl disable --now $dm.service
            fi
        done
        echo "🚀 Greetd servisi aktif ediliyor..."
        sudo systemctl enable greetd.service
    fi
fi

echo "✅ Kurulum tamamlandı! Değişikliklerin etkili olması için oturumu kapatıp açmayı veya sistemi yeniden başlatmayı unutmayın."
