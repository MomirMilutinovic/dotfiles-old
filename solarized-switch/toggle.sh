#!/bin/bash

termite_conf=${HOME}/.config/termite/config
poly_conf=${HOME}/.config/polybar/config
oldmode=$([[ -z $(diff $poly_conf ${poly_conf}-dark) ]] && echo 'dark' || echo 'light')
newmode=$([[ $oldmode == 'dark' ]] && echo 'light' || echo 'dark')

# i3
# Toggle the following 2 lines if my PR gets merged in upstream i3-style
#i3-style solarized-transparent-${newmode} -o ${HOME}/.config/i3/config --reload
#i3${HOME}/.config/i3/config --reload

# rofi
ln -sf ${HOME}/.config/i3/config-$newmode ${HOME}/.config/i3/config

# Background
feh --bg-fill "${HOME}/wallpaper-${newmode}.png"

# .Xresources
ln -sf ${HOME}/.Xresources.$newmode ${HOME}/.Xresources
xrdb -load ${HOME}/.Xresources

# Termite
ln -sf ${termite_conf}-$newmode ${termite_conf}
killall -USR1 termite

# polybar
ln -sf ${HOME}/.config/polybar/config-$newmode ${HOME}/.config/polybar/config
killall polybar
polybar top &> /dev/null &
disown
polybar bottom &> /dev/null &
disown

# GTK 3
gsettings set org.gnome.desktop.interface gtk-theme "Solarized-"$newmode


# Vim
#pattern="colorscheme solarized"
#perl -e "s/${pattern}${oldmode}/${pattern}${newmode}/g" -pi ${HOME}/.vimrc
#for socket in /tmp/nvimsocket*; do
#    nvr --servername $socket --remote-send ",B<Enter>";
#done;

function reload_gtk_theme() {
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
  gsettings set org.gnome.desktop.interface gtk-theme ''
  sleep 1
  gsettings set org.gnome.desktop.interface gtk-theme $theme
}

# GTK2 apps (e.g Gimp, Thunar, Deluge, Chrome)
echo "include \"/usr/share/themes/Solarized$([[ $newmode == 'dark' ]] \
    && echo 'Dark')/gtk-2.0/gtkrc\"" > ${HOME}/.gtkrc-2.0
python2.7 ${HOME}/scripts/gtkreload &


# Atom
rm "${HOME}/.atom/config.cson"
cp "${HOME}/.atom/config-${newmode}.cson" "${HOME}/.atom/config.cson"

if [[ $(ps auxw|grep chrome|grep -v grep|wc -l) -gt 0 ]]; then
    mapfile -t workspaces <<< $(i3-msg -t get_workspaces | jq -r '.[] | .name')

    # Add save-tree logic here
    for ws in "${workspaces[@]}"; do
        i3-save-tree --workspace "$ws" > ~/.config/i3sessions/workspace-${ws:0:1}.json
        # Swallows all
        perl -e "s/\/\/ \"/\"/g" -pi ~/.config/i3sessions/workspace-${ws:0:1}.json
    done


    # Swallow other windows
    ids=$(xdotool search --onlyvisible --name '.*')
    IFS='
    '
    ids=( $ids )
    for id in "${ids[@]}"; do
        xdotool windowunmap $id
    done

    # Restore logic
    for ws in "${workspaces[@]}"; do
        i3-msg "workspace $ws; append_layout ~/.config/i3sessions/workspace-${ws:0:1}.json"
    done

    # Go back to first workspace
    i3-msg "workspace ${workspaces[0]}"


    # Give some time for i3 to append the layout and chrome to start
    sleep 2

    # Unswallow other windows
    for id in "${ids[@]}"; do
        xdotool windowmap $id
    done
fi
