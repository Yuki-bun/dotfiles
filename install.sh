echo "----------Starting Setup----------"

echo "Updating apt"
sudo apt update

echo "Installing Nvim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
sudo mv squashfs-root / && sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

echo "Installing tmux"
sudo apt install tmux -y

echo "Installing stow"
sudo apt install stow -y

echo "Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes y | ~/.fzf/install
source ~/.bashrc

echo "Installing lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

echo "Installing fortune for tmux"
sudo apt install fortune -y

echo "Install zoxide"
conda install -c conda-forge zoxide -y
eval "$(zoxide init bash)"

DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"

echo "Setting up simlinks"
ln -s $DOTFILES_DIR/nvim/.config/nvim ~/.config/nvim
ln -s $DOTFILES_DIR/tmux/.tmux.conf ~/.tmux.conf



echo "----------Setup Complete----------"
