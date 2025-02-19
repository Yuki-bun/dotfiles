print() {
    local message="$1"
    local width=${2:-60}
    local message_length=${#message}
    local dash_length=$(( (width - message_length - 2) / 2 ))

    printf '%*s' "$dash_length" '' | tr ' ' -
    printf ' %s ' "$message"
    printf '%*s' "$dash_length" '' | tr ' ' -

    if [ $(( (width - message_length - 2) % 2 )) -ne 0 ]; then
        printf '-'
    fi

    echo
}


print "Starting Setup"

print "Updating apt"
sudo apt update

print "Install tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

print "Installing tmux"
sudo apt install tmux -y

print "Installing stow"
sudo apt install stow -y

print "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/bin/.fzf
~/.local/bin/.fzf/install --xdg --key-bindings --completion --update-rc
source ~/.config/fzf/fzf.bash

print "Installing lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

print "Installing fortune for tmux"
sudo apt install fortune -y

print "Install zoxide"
conda install -c conda-forge zoxide -y

DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"

print "Setting up simlinks"
ln -s $DOTFILES_DIR/.tmux.conf ~/.tmux.conf



eval "$(zoxide init bash)"
print "SetuphComplete"
