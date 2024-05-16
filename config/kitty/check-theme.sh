#!/usr/bin/env bash

is_os_dark=$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode')

kitty_theme_file=~/.config/kitty/current-theme.conf

dark_theme_name="Solarized Dark"
light_theme_name="Solarized Light"

if [ "$is_os_dark" = "true" ]; then
	kitty +kitten themes --reload-in=all --dump-theme "$dark_theme_name" >"$kitty_theme_file"
	kitty @ set-colors --all --configured "$kitty_theme_file"
else
	kitty +kitten themes --reload-in=all --dump-theme "$light_theme_name" >"$kitty_theme_file"
	kitty @ set-colors --all --configured "$kitty_theme_file"
fi
