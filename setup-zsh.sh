#!/usr/bin/env bash

IS_DOCKER_IMAGE="$1"
export IS_DOCKER_IMAGE

# shellcheck source=/dev/null
source ./lib.sh
# shellcheck source=/dev/null
source ./setup-zsh_functions.sh



pr_info "Installation starting for: [ $OSTYPE ]"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    res=$(apt-get -y install zsh 2>&1)
    log_result "$?" "$res" "Installing zsh..."
    res=$(chsh -s "$(which zsh)")
    log_result "$?" "$res" "Setting zsh as default shell..."
elif [[ "$OSTYPE" == "linux-musl" ]]; then
    res=$(sudo apk add zsh 2>&1)
    log_result "$?" "$res" "Installing zsh..."
    
    res=$(chsh -s $(which zsh))
    log_result "$?" "$res" "Setting zsh as default shell..."
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install zsh
    chsh -s /usr/local/bin/zsh
elif [[ "$OSTYPE" == "cygwin" ]]; then
    pr_err "NOT SUPPORTED YET"
elif [[ "$OSTYPE" == "msys" ]]; then
    pr_err "NOT SUPPORTED YET"
elif [[ "$OSTYPE" == "win32" ]]; then
    pr_err "NOT SUPPORTED YET"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    pr_err "NOT SUPPORTED YET"
else
    pr_info "UKNOWN OS"
    pr_err "NOT SUPPORTED"
    exit 1
fi

# Install oh-my-zsh
res=$(sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>&1)
log_result "$?" "$res" "Installing oh-my-zsh ..."

# Install fzf
res=$(git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf  2>&1)
log_result "$?" "$res" "Cloning fzf to ~/.fzf ..."
res=$(~/.fzf/install 2>&1)
log_result "$?" "$res" "Installing fzf ..."

# Install zsh-autosuggestions
res=$(git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions  2>&1)
log_result "$?" "$res" "Cloning and installing zsh-autosuggestions..."

res=$(git clone https://github.com/mbrubeck/compleat.git ~/compleat 2>&1)
log_result "$?" "$res" "Cloning compleat ..."
s/compleat.d

# Call function to update the ~/.zshrc file
cp ALIASES "$HOME/.oh-my-zsh/custom/ALIASES"
log_result "$?" "$res" "Copying ALIASES file ..."

update_file
