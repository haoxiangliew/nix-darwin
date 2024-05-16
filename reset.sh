#!/usr/bin/env bash

# warn before doing anything
read -p "This will reset the repository to the latest version from GitHub. Are you sure? (y/N) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	git fetch origin
	git reset --hard origin/master

	# prompt to remove old files
	git clean -n -f
	read -p "Do you want to remove these files? (y/N) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		git clean -f
	fi
fi
