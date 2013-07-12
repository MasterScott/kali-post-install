#!/bin/bash

. ask.sh

ask "Do you want to change some Gnome 3 settings?" Y || exit 3

gsettings set org.gnome.gnome-panel.layout toplevel-id-list "['top-panel']"
dconf write /org/gnome/gnome-panel/layout/objects/workspace-switcher/toplevel-id "'top-panel'"
dconf write /org/gnome/gnome-panel/layout/objects/window-list/toplevel-id "'top-panel'"
dconf write /org/gnome/gnome-panel/layout/toplevels/top-panel/orientation "'top'" #"'right'" # Issue with window-list
dconf write /org/gnome/gnome-panel/layout/objects/menu-bar/pack-type "'start'"
dconf write /org/gnome/gnome-panel/layout/objects/menu-bar/pack-index 0
dconf write /org/gnome/gnome-panel/layout/objects/window-list/pack-type "'start'" # "'center'"
dconf write /org/gnome/gnome-panel/layout/objects/window-list/pack-index 5 #0
dconf write /org/gnome/gnome-panel/layout/objects/workspace-switcher/pack-type "'end'"
dconf write /org/gnome/gnome-panel/layout/objects/clock/pack-type "'end'"
dconf write /org/gnome/gnome-panel/layout/objects/user-menu/pack-type "'end'"
dconf write /org/gnome/gnome-panel/layout/objects/notification-area/pack-type "'end'"
dconf write /org/gnome/gnome-panel/layout/objects/workspace-switcher/pack-index 1
dconf write /org/gnome/gnome-panel/layout/objects/clock/pack-index 2
dconf write /org/gnome/gnome-panel/layout/objects/user-menu/pack-index 3
dconf write /org/gnome/gnome-panel/layout/objects/notification-area/pack-index 4

#--- Enable Auto hide
#dconf write /org/gnome/gnome-panel/layout/toplevels/top-panel/auto-hide true

#--- Add top 10 tools to toolbar
dconf load /org/gnome/gnome-panel/layout/objects/object-10-top/ << EOT
[instance-config]
menu-path='applications:/Kali/Top 10 Security Tools/'
tooltip='Top 10 Security Tools'

[/]
object-iid='PanelInternalFactory::MenuButton'
toplevel-id='top-panel'
pack-type='start'
pack-index=4
EOT
dconf write /org/gnome/gnome-panel/layout/object-id-list "$(dconf read /org/gnome/gnome-panel/layout/object-id-list | sed "s/]/, 'object-10-top']/")"

#--- Show desktop
dconf load /org/gnome/gnome-panel/layout/objects/object-show-desktop/ << EOT
[/]
object-iid='WnckletFactory::ShowDesktopApplet'
toplevel-id='top-panel'
pack-type='end'
pack-index=0
EOT
dconf write /org/gnome/gnome-panel/layout/object-id-list "$(dconf read /org/gnome/gnome-panel/layout/object-id-list | sed "s/]/, 'object-show-desktop']/")"

# remove nasty notifications
apt-get install -y notify-osd

#--- Fix icon top 10 shortcut icon
#convert /usr/share/icons/hicolor/48x48/apps/k.png -negate /usr/share/icons/hicolor/48x48/apps/k-invert.png
#/usr/share/icons/gnome/48x48/status/security-medium.png

#--- Enable only two workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 2 #gconftool-2 --type int --set /apps/metacity/general/num_workspaces 2 #dconf write /org/gnome/gnome-panel/layout/objects/workspace-switcher/instance-config/num-rows 4
gsettings set org.gnome.shell.overrides dynamic-workspaces false

#--- Smaller title bar
#sed -i "/title_vertical_pad/s/value=\"[0-9]\{1,2\}\"/value=\"0\"/g" /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml
#sed -i 's/title_scale=".*"/title_scale="small"/g' /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Droid Bold 10' # 'Cantarell Bold 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-uses-system-font false

#--- Hide desktop icon
dconf write /org/gnome/nautilus/desktop/computer-icon-visible false

#--- Add "open with terminal" on right click menu
apt-get -y install nautilus-open-terminal

#--- Restart GNOME panel to apply/take effect (Need to restart xserver)
#killall gnome-panel && gnome-panel& #Still need to logoff!

mkdir -p /root/.config/gtk-2.0/
if [ -e /root/.config/gtk-2.0/gtkfilechooser.ini ]; then sed -i 's/^.*ShowHidden.*/ShowHidden=true/' /root/.config/gtk-2.0/gtkfilechooser.ini; else echo -e "\n[Filechooser Settings]\nLocationMode=path-bar\nShowHidden=true\nExpandFolders=false\nShowSizeColumn=true\nGeometryX=66\nGeometryY=39\nGeometryWidth=780\nGeometryHeight=618\nSortColumn=name\nSortOrder=ascending" > /root/.config/gtk-2.0/gtkfilechooser.ini; fi #Open/save Window -> Right click -> Show Hidden Files: Enabled
dconf write /org/gnome/nautilus/preferences/show-hidden-files true
if [ ! -e /root/.gtk-bookmarks.bkup ]; then cp -f /root/.gtk-bookmarks{,.bkup}; fi
echo -e 'file:///var/www www\nfile:///usr/share apps\nfile:///tmp tmp\nfile:///usr/local/src/ src' >> /root/.gtk-bookmarks #Places -> Location: {/usr/share,/var/www/,/tmp/, /usr/local/src/} -> Bookmarks -> Add bookmark



