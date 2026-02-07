setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
HISTSIZE=10000
SAVEHIST=10000
# mkdir -p "$XDG_CACHE_HOME/zsh"   # <- make sure folder exists

# --- History file ---
HISTFILE="$XDG_CACHE_HOME/zsh/zsh_history"


# Available completion styles for ez-compinit: gremlin, ohmy, prez, zshzoo
# You can add your own too. To see all available completion styles
# run 'compstyle -l'
zstyle ':plugin:ez-compinit' 'compstyle' 'gremlin'
zstyle ':antidote:bundle' use-friendly-names on

# source antidote
ANTIDOTE_HOME="${XDG_CACHE_HOME}/antidote"
source "${ZDOTDIR:-~}/.antidote/antidote"


# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
# Preview file content using bat (https://github.com/sharkdp/bat)	
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --prompt='Files > '
  --walker-skip .git,node_modules,target"
  # --bind 'ctrl-/:change-preview-window(down|hidden|)'
  # --header 'Press CTRL-/ to change preview window'
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --preview 'tree -C {}'
  --walker-skip .git,node_modules,target"
export FZF_DEFAULT_OPTS="--height ~40% --inline-info --layout reverse
--color="bg+:-1,fg:gray,fg+:white,border:black,spinner:0,hl:yellow,header:blue,info:green,pointer:red,marker:yellow,prompt:gray,hl+:red"
--multi --border=sharp
--pointer '→'
--preview='if [ -d {} ]; then tree -C {}; else bat -n --color=always {}; fi' --preview-window='45%,border-sharp'
--bind='enter:execute($EDITOR {+})'
--bind='del:execute(rm -ri {+})'
--bind='ctrl-p:toggle-preview'
--bind='ctrl-d:change-prompt(Dirs > )'
--bind='ctrl-d:+reload(fd --type d --hidden --exclude .git)'
--bind='ctrl-d:+change-preview(tree -C {})'
--bind='ctrl-d:+refresh-preview'
--bind='ctrl-f:change-prompt(Files > )'
--bind='ctrl-f:+reload(rg --files --hidden --glob "!.git")'
--bind='ctrl-f:+change-preview(bat -n --color=always {})'
--bind='ctrl-f:+refresh-preview'
--bind='ctrl-a:select-all'
--bind='ctrl-x:deselect-all'
--header '
CTRL-D to display directories | CTRL-F to display files
CTRL-A to select all | CTRL-x to deselect all
ENTER to edit | DEL to delete
CTRL-P to toggle preview'
"
# fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"
# Use the CLI ripgrep to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git'

# Use the CLI fd to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
# export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git"'
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'


source <(fzf --zsh)

# Colorize manpages via bat
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"

alias cat="bat --theme auto:system --theme-dark default --theme-light GitHub"
# e.g. help ls. #uses bat to syntax highlight in help syntax file. 
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
# Use global aliases to override -h and --help entirely:
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load
autoload -Uz promptinit && promptinit && prompt pure