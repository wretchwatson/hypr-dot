# .bashrc
# Antigravity tarafından hazırlanan modern ve estetik Bash yapılandırması

# Etkileşimli değilse bir şey yapma
[[ $- != *i* ]] && return

# --- Ortam Değişkenleri ---
export EDITOR='nano' # Ya da 'vim' / 'nvim'
export VISUAL='nano'
export LANG=tr_TR.UTF-8
export LC_ALL=tr_TR.UTF-8

# --- Geçmiş (History) Ayarları ---
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend # Geçmişi dosyaya ekle, üzerine yazma
shopt -s checkwinsize # Her komuttan sonra pencere boyutunu kontrol et

# --- Takma Adlar (Aliases) ---

# ls yerine modern eza kullanımı
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first --color=always'
    alias ll='eza -alF --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -alF'
fi

# cat yerine modern bat kullanımı
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
fi

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
alias orphan='sudo pacman -Rs $(pacman -Qtdq)' # Yetim paketleri kaldır

# Paru kısayolları (AUR)
if command -v paru >/dev/null 2>&1; then
    alias pup='paru -Syu'            # Sistem + AUR güncelle
    alias pin='paru -S'              # AUR paket kur
    alias psearch='paru -Ss'         # AUR paket ara
    alias pinfo='paru -Si'           # AUR paket bilgisi
    alias pclean='paru -Sc'          # AUR cache temizle
    alias pupgrade='paru -Sua'       # Sadece AUR güncelle
fi

# Nano kısayolları
alias n='nano'
alias sn='sudo nano'

# Sistem araçları renklendirme
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# --- Araç Başlatma (Tools Init) ---

# Starship Prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Zoxide (Modern cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    alias cd='z'
fi

# FZF (Bulanık Arama)
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
fi

# --- Otomatik Tamamlama (Completion) ---

# Bash-completion paketini yükle
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Pacman ve Paru kısayolları için akıllı tamamlama
_comp_pacman_pkg_all() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(pacman -Slq)" -- "$cur"))
}

_comp_pacman_pkg_installed() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(pacman -Qq)" -- "$cur"))
}

_comp_paru_pkg_all() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    # Paru hem repo hem AUR paketlerini tamamlar
    COMPREPLY=($(compgen -W "$(paru -Slq)" -- "$cur"))
}

# Pacman tamamlama atamaları
complete -F _comp_pacman_pkg_all in up search info
complete -F _comp_pacman_pkg_installed un uns list qm

# Paru tamamlama atamaları
if command -v paru >/dev/null 2>&1; then
    complete -F _comp_paru_pkg_all pin pup psearch pinfo pupgrade
    complete -F _comp_pacman_pkg_installed pclean # pclean genelde kurulu olanlarla ilgili olabilir
fi

# --- Fonksiyonlar ---

# Dosya arşivlerini kolayca çıkarma
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' çıkarılamadı" ;;
    esac
  else
    echo "'$1' geçerli bir dosya değil"
  fi
}

# Man sayfalarını renklendirme
man() {
    LESS_TERMCAP_mb=$'\e[1;31m' \
    LESS_TERMCAP_md=$'\e[1;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;32m' \
    command man "$@"
}
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
