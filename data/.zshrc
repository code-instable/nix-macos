# ╔═════════════════╗
# ⓘ  Initialization ║
# ╚═════════════════╝
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone "https://github.com/zdharma-continuum/zinit" "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"
# add Powerlevel10k
zinit ice depth=1 ; zinit light romkatv/powerlevel10k

# ╔════════════════╗
# ⓘ  Zinit Plugins ║
# ╚════════════════╝
zinit light 'zdharma-continuum/fast-syntax-highlighting'
zinit light 'zsh-users/zsh-history-substring-search'
zinit light 'Aloxaf/fzf-tab'
zinit light 'marlonrichert/zsh-autocomplete'

# ╔═══════════════════╗
# ⓘ  History Settings ║
# ╚═══════════════════╝
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"
#
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
# enable comment support
setopt interactivecomments

# ╔═════════╗
# ⓘ  Colors ║
# ╚═════════╝
ls_style_file="$HOME/.custom/style/vivid-mocha-ls"
export LS_COLORS="$(cat $ls_style_file)"
export EZA_COLORS="$(cat $ls_style_file)"
unset ls_style_file

# ╔══════════════╗
# ⓘ  Keybindings ║
# ╚══════════════╝
# This makes Tab and ShiftTab, when pressed on the command line, enter the menu instead of inserting a completion
# https://github.com/marlonrichert/zsh-autocomplete#configuration
# keybinds : `infocmp -L1`
bindkey              '^I' menu-select
bindkey "${terminfo[kcbt]}" menu-select
# This makes Tab and ShiftTab move the selection in the menu right and left, respectively, instead of exiting the menu:
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete

# ctrl + up/down 
bindkey '^z' history-search-backward
bindkey '^s' history-search-forward

export PATH="$PATH:/Users/instable/.modular/bin"
export PATH="$PATH:$HOME/.local/bin"

# ╔════════════════════════╗
# ⓘ  Sourcing environments ║
# ╚════════════════════════╝
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/Users/instable/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/instable/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    # custom aliases
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# ╔═══════════════════════════╗
# ⓘ  Custom Functions/Aliases ║
# ╚═══════════════════════════╝
for file in $HOME/.custom/functions/zsh/*.zsh; do
  source "${file}"
done
source "${HOME}/.custom/alias.zsh"
source "${HOME}/.custom/zellij.zsh"


# ╔══════════════╗
# ⓘ  Completions ║
# ╚══════════════╝
[[ -f $(which rbw) ]] && source <(rbw gen-completions zsh)
[[ -f $(which gh) ]] && source <(gh completion --shell zsh)
[[ -f $(which magic) ]] && source <(magic completion --shell zsh)
[[ -f $(which fzf) ]] && source <(fzf --zsh)

# ╔════════════╗
# ⓘ  Execution ║
# ╚════════════╝
micromamba activate latest
eval "$(zoxide init --cmd cd zsh)"
