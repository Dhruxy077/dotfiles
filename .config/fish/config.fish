# ============================================================================
# FISH SHELL CONFIGURATION
# ~/.config/fish/config.fish
# ============================================================================

# ============================================================================
# ENVIRONMENT VARIABLES & SHELL SETTINGS
# ============================================================================

# Editor
set -gx EDITOR nvim

# Disable fish greeting
set fish_greeting

# Set default cursor style
set fish_cursor_default block

# ============================================================================
# INTERACTIVE SESSION SETUP
# ============================================================================

if status is-interactive
    # 1. Print system info (Moved here so it doesn't break background scripts)
    # fastfetch

    # 2. Initialize Homebrew (if installed)
    if test -f /home/linuxbrew/.linuxbrew/bin/brew
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        atuin init fish | source
    end

    # 3. Setup Starship Prompt
    function starship_transient_prompt_func
        starship module character
    end

    function starship_transient_rprompt_func
        starship module custom.transient_time
    end

    starship init fish | source

    # ============================================================================
    # ALIASES
    # ============================================================================

    # File listing
    alias ls='eza --icons --group-directories-first -l'
    alias tree='eza --tree --icons'

    # Modern command replacements
    alias cat='bat'
    alias grep='rg'
    alias find='fd'
    alias top='btop'

    # Initialize zoxide (smart cd)
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end
end
