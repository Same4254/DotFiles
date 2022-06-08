sudo apt update -y

sudo apt-get install i3 -y
sudo apt-get install i3blocks -y
sudo apt-get install rxvt-unicode xsel -y
sudo apt-get install neovim -y
sudo apt-get install lf -y
sudo apt-get install python3-pip -y
sudo pip3 install cmake
suto apt-get install shutter -y
sudo apt-get install feh -y

sudo mkdir ~/Pictures/Backgrounds
cp ./BestBackground.png ~/Pictures/Backgrounds

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo 'cp' -rf ./.config/* ~/.config

nvim +'PlugInstall --sync' +qa
