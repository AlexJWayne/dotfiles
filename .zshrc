# Start Autocompletion Engine
# source ~/.zsh-autocomplete/zsh-autocomplete.plugin.zsh

eval "$(fnm env --use-on-cd)"

alias g="git"
alias sso="aws sso login --profile DEV && aws sso login --profile PROD"

export AWS_PROFILE=DEV

# pnpm
export PNPM_HOME="/Users/alex/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# VSCode CLI
export PATH="$PATH:/Users/alex/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Created by `pipx` on 2024-09-30 23:51:03
export PATH="$PATH:/Users/alex/.local/bin"

# Zig version manager
# export PATH="$PATH:$HOME/.zvm/bin"
# export PATH="$PATH:$HOME/.zvm/self"
export PATH="$PATH:$HOME/zig"

# https://github.com/zsh-users/zsh-autosuggestion
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Up arrow searches history with a prefix of what you typed so far
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# PostgreSQL
export PATH="$PATH:/opt/homebrew/opt/postgresql@15/bin"

# Oh my posh
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/my-gruv.json)"

# NX Autocomplete
# source ~/.nx-completion/nx-completion.plugin.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion



# Update terminal/tab title to the running command
# Prune some noise out of commonly run NX commands for work
preexec() {
    local cmd="$1"
    cmd=${cmd/#nx run /}
    cmd="${cmd%% --host 0.0.0.0}"
    print -Pn "\e]2;${cmd}\a"
}
precmd() {
    print -Pn "\e]2;%~\a"
}
