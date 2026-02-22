#### INTERACTIVE ####
if not status is-interactive
    return
end

#### ENV ####
# Set environment variables overwritten in the system's bash configuration from
# ~/.config/environment.d/
set -gx EDITOR nvim
fish_add_path "$HOME/.local/share/cargo/bin"
fish_add_path "$HOME/.local/bin"

#### ALIASES ####
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Activate colors and flags
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias diff='diff --color=auto -u'
alias less='less -Ri'
alias df='df -hi'
alias ls='ls --color=auto --group-directories-first -hv'
alias ll='ls -l'
alias la='ls -lA'

alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'

alias cat='bat --theme="Visual Studio Dark+"'
alias icat='wezterm imgcat'

# Recurrently used commands
abbr --add up 'sudo dnf update && flatpak update'

#### MY FUNCTIONS ####
function notes --description 'Edit notes'
    set -l file (fd -tf -e md -e typ . ~/notes | fzf --preview "bat --plain --color=always {}")
    if test -n "$file"
        pushd ~/notes; and command nvim $file; and popd
    end
end

# Modified from: https://yazi-rs.github.io/docs/quick-start
function y --description "Run yazi and change cwd"
    if not type -q yazi
        echo "yazi is not installed"
        return 1
    end
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end


#### FISH FUNCTIONS ####
function fish_greeting
    # Run fastfetch on startup if:
    #   - the command exists
    #   - not running inside Vim or Neovim
    #   - not running inside tmux or zellij
    #   - not running inside SSH
    if type -q fastfetch; \
        and not set -q NVIM; \
        and not set -q VIMRUNTIME; \
        and not set -q TMUX; \
        and not set -q ZELLIJ; \
        and not set -q SSH_TTY
            command fastfetch
    end
end

function fish_user_key_bindings
    # I will use arrow for previous commands
    bind ctrl-p prevd-or-backward-word # prevd when empty
    bind ctrl-n nextd-or-forward-word  # nextd when empty

    # Completion
    bind ctrl-f accept-autosuggestion
    bind ctrl-r history-pager        # Search command history
    bind ctrl-s pager-toggle-search  # Search pager

    # Common CLI editing
    bind ctrl-b edit_command_buffer
    bind ctrl-l clear-screen
    bind ctrl-c clear-commandline
    bind ctrl-d delete-or-exit
    bind ctrl-z undo

    # Emacs things
    bind ctrl-e end-of-line
    bind ctrl-a beginning-of-line
    bind ctrl-h backward-kill-word           # ctrl-backspace
    bind ctrl-w backward-kill-path-component # delete previous word
    bind ctrl-u backward-kill-line           # delete to start
    bind ctrl-k kill-line                    # delete until end
    bind ctrl-t transpose-words              # swap two previous words

    bind ctrl-y yank
    bind ctrl-v fish_clipboard_paste
    bind ctrl-x fish_clipboard_copy

    # Check with `fish_key_reader` because terminals things
    # - ctrl-m == enter
    # - ctrl-i == tab
    # - ctrl-h == ctrl-backspace
    #
    # Empty keys
    # - ctrl-q
    # - ctrl-o
    # - ctrl-g
    # - ctrl-j

    # # Vim + Emacs
    # # Execute this once per mode that emacs bindings should be used in
    # fish_default_key_bindings -M insert
    #
    # # Then execute the vi-bindings so they take precedence when there's a conflict.
    # # Without --no-erase fish_vi_key_bindings will default to
    # # resetting all bindings.
    # # The argument specifies the initial mode (insert, "default" or visual).
    # fish_vi_key_bindings --no-erase insert
end

function fish_prompt --description 'Write out the prompt'
    #### STATUS ####
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    #### GIT STUFF ####
    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 1
    end
    if not set -q __fish_git_prompt_hide_untrackedfiles
        set -g __fish_git_prompt_hide_untrackedfiles 1
    end
    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch magenta --bold
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream informative
    end
    if not set -q __fish_git_prompt_color_dirtystate
        set -g __fish_git_prompt_color_dirtystate blue
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_untrackedfiles
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate green --bold
    end

    #### USE '$' FOR USER AND '#' FOR ROOT ####
    set -l color_cwd
    set -l suffix
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        else
            set color_cwd $fish_color_cwd
        end
            set suffix '#'
    else
        set color_cwd $fish_color_cwd
        set suffix '$'
    end

    #### PRINT WORKING DIRECTORY ####
    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color normal

    #### PRINT VERSION CONTROL ####
    printf '%s ' (fish_vcs_prompt)

    #### PRINT STATUS ####
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    echo -n $prompt_status
    set_color normal

    #### PRINT SUFFIX ####
    echo -n "$suffix "
end
