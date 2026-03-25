# .config/fish/config.fish
# Antigravity tarafından hazırlanan modern ve estetik Fish yapılandırması

# --- Ortam Değişkenleri ---
set -gx EDITOR nano
set -gx VISUAL nano
set -gx LANG tr_TR.UTF-8
set -gx LC_ALL tr_TR.UTF-8

# --- Fish Selamlama ---
function fish_greeting
    if type -q pokemon-colorscripts
        pokemon-colorscripts -r --no-title
    end
end

# --- Takma Adlar (Aliases) - Bash'ten Aktarılanlar ---

# ls yerine modern eza kullanımı
if type -q eza
    alias l='eza --icons --group-directories-first --color=always'
    alias ll='eza -alF --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -alF'
end

# cat yerine modern bat kullanımı
if type -q bat
    alias cat='bat --paging=never'
end

# grep renklendirme
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Navigasyon kolaylıkları
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .2='cd ../..'
alias .3='cd ../../..'

# Git kolaylıkları
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all'

# Pacman kısayolları
alias up='sudo pacman -Syu'          # Sistem güncelle
alias in='sudo pacman -S --needed'   # Paket kur
alias un='sudo pacman -R'            # Paket kaldır
alias uns='sudo pacman -Rs'          # Paket + bağımlılıkları kaldır
alias search='pacman -Ss'            # Paket ara
alias info='pacman -Si'              # Paket bilgisi
alias list='pacman -Q'               # Kurulu paketler
alias qm='pacman -Qs'                # Kurulu paketi ara
alias clean='sudo pacman -Sc'        # Cache temizle
alias orphan='sudo pacman -Rs (pacman -Qtdq)' # Yetim paketleri kaldır

# Paru kısayolları (AUR)
if type -q paru
    alias pup='paru -Syu'            # Sistem + AUR güncelle
    alias pin='paru -S'              # AUR paket kur
    alias psearch='paru -Ss'         # AUR paket ara
    alias pinfo='paru -Si'           # AUR paket bilgisi
    alias pclean='paru -Sc'          # AUR cache temizle
    alias pupgrade='paru -Sua'       # Sadece AUR güncelle
end

# Nano kısayolları
alias n='nano'
alias sn='sudo nano'

# Sistem araçları renklendirme
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# --- Araç Başlatma (Tools Init) ---

# Starship Prompt
if type -q starship
    starship init fish | source
end

# Zoxide (Modern cd)
if type -q zoxide
    zoxide init fish | source
end

# --- Fonksiyonlar ---

# Dosya arşivlerini kolayca çıkarma
function ex
    if test -f "$argv[1]"
        switch "$argv[1]"
            case '*.tar.bz2'
                tar xjf "$argv[1]"
            case '*.tar.gz'
                tar xzf "$argv[1]"
            case '*.bz2'
                bunzip2 "$argv[1]"
            case '*.rar'
                unrar x "$argv[1]"
            case '*.gz'
                gunzip "$argv[1]"
            case '*.tar'
                tar xf "$argv[1]"
            case '*.tbz2'
                tar xjf "$argv[1]"
            case '*.tgz'
                tar xzf "$argv[1]"
            case '*.zip'
                unzip "$argv[1]"
            case '*.Z'
                uncompress "$argv[1]"
            case '*.7z'
                7z x "$argv[1]"
            case '*'
                echo "'$argv[1]' çıkarılamadı"
        end
    else
        echo "'$argv[1]' geçerli bir dosya değil"
    end
end

# Man sayfalarını renklendirme
function man
    set -lx LESS_TERMCAP_mb \e'[1;31m'
    set -lx LESS_TERMCAP_md \e'[1;31m'
    set -lx LESS_TERMCAP_me \e'[0m'
    set -lx LESS_TERMCAP_se \e'[0m'
    set -lx LESS_TERMCAP_so \e'[01;44;33m'
    set -lx LESS_TERMCAP_ue \e'[0m'
    set -lx LESS_TERMCAP_us \e'[1;32m'
    command man $argv
end
