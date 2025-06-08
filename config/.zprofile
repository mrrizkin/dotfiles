if [[ "$(tty)" == "/dev/tty1" ]]; then
    pgrep dwm || startx "$HOME"/.config/startx/xinitrc
fi
