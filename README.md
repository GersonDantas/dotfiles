# My Dot files:

## Automate this
```sh
### Instalando Git e coisas básicas
xcode-select --install

### Oh My ZSH
sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm 
rm -rf ~/.zshrc

### Install Powerlevel10k

#### Clone the repository:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### Setup dot dotfiles
git clone --recurse-submodules https://github.com/GersonDantas/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

### Instalando o Home brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/mariosouto/.profile && eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file ~/.dotfiles/Brewfile

### Finalização
cd ~ && mkdir ./dev
```

## How to extract current installed files?
```sh
cd ~/.dotfiles && brew bundle dump --force && git add . && git commit -m "update" && git push 
```
