# My dotfiles repo

This repo keeps track of the dotfiles of my machine and can be cloned to apply the configs easily on a new machine. The directories of this repo can be stowed using gnu stow, which creates symlinks on the new machine
<br><br>
## Steps for stowing the config:


**Step 1:**
Install gnu stow on your linux distribution
***


**Step 2:**
Clone this repo on to your home directory
```
git clone https://github.com/Manideep0905/dotfiles.git
```
***

**Step 3:**
run the ls command. You will see the following directories
```
alacritty  backgrounds  i3  nvim  picom  README.md  rofi  scripts  starship  tmux
```
***

**Step 4:**
Now you can stow any directory in this repo by just doing
```
stow <directory_name>
```
***

**Step 5:**
Let's say you want to copy the neovim config
```
stow nvim
```
