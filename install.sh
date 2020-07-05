
echo -n "Instalar  dependencias"

dnf install git nodejs fzf ripgrep

echo -n "Creando Symlinks"

ln -s $HOME/dotfiles/vim/vimrc $HOME/.vimrc
ln -s $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf.local
echo 'listo!'

echo -n "Instalando  Pathogen y vundle"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


vim  +PluginInstall +q
