# Auto-attach to tmux on SSH login
if [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ]; then
    if tmux has-session -t main 2>/dev/null; then
        printf '\n  Existing tmux session detected.\n\n'
        printf '  [1] Attach to shared session\n'
        printf '  [2] Start new session\n'
        printf '  [q] Skip (plain shell)\n\n'
        printf '  > '
        read -r choice
        case $choice in
            1) exec tmux attach-session -t main ;;
            2) exec tmux new-session ;;
            q|Q) ;;
            *) ;;
        esac
    else
        exec tmux new-session -s main
    fi
fi
