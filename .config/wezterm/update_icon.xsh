#!/usr/bin/env xonsh

cp wezterm.icns /Applications/WezTerm.app/Contents/Resources/terminal.icns
rm /var/folders/*/*/*/com.apple.dock.iconcache
rm -r /var/folders/*/*/*/com.apple.iconservices*
touch /Applications/WezTerm.app
killall Dock