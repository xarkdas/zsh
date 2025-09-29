#!/bin/bash
# Arch Linux Prod-Ready Zsh + FZF Quick-Access + Auto Paket Kontrol

echo "🔹 Arch Linux Prod-Ready Zsh Kurulumu Başlıyor..."

sudo pacman -Syu --noconfirm

PACKAGES=(zsh git curl wget autojump fzf ttf-dejavu ttf-font-awesome nerd-fonts-complete bat)
for pkg in "${PACKAGES[@]}"; do
    if ! pacman -Qi $pkg &> /dev/null; then
        echo "📦 Paket eksik: $pkg. Kuruluyor..."
        sudo pacman -S --noconfirm $pkg
    fi
done

chsh -s $(which zsh)

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✨ Oh My Zsh zaten yüklü."
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "🌈 Powerlevel10k zaten yüklü."
fi

PLUGINS=(zsh-autosuggestions zsh-syntax-highlighting)
for plugin in "${PLUGINS[@]}"; do
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin" ]; then
        git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin
    else
        echo "🔧 $plugin zaten yüklü."
    fi
done

cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump history-substring-search sudo z fzf)
source $ZSH/oh-my-zsh.sh
[[ -s /usr/share/autojump/autojump.sh ]] && source /usr/share/autojump/autojump.sh

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time background_jobs)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER="…"
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{cyan}╭─%f"
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="%F{cyan}╰─%f"
POWERLEVEL9K_VCS_BRANCH_ICON="\uE0A0"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="black"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="red"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="white"
POWERLEVEL9K_MODE='nerdfont-complete'

alias ll='ls -lha'
alias gs='git status'
alias gp='git pull'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log --oneline --graph --all'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias ff='find . -type f | fzf --preview "bat --style=numbers --color=always {}"'
alias fh='history | fzf'
alias cdq='cd $(find . -type d | fzf)'
EOF

source ~/.zshrc

echo "✅ Prod-Ready Zsh + FZF Quick-Access ortamınız hazır! Terminali yeniden açın."
