#!/bin/bash

# Backup file name
fdir=$HOME/Documents/Backups
fname=bk-$(date +%Y-%m-%d).zip

# List of important directories with absolute paths
dirs="$HOME/git $HOME/npm $HOME/work $HOME/server $HOME/Documents $HOME/Pictures"

# List of excluded files
excluded="*/node_modules/* *.zip"

# Check if directories exist before creating the backup
for dir in $dirs; do
    if [ ! -d "$dir" ]; then
        echo "Directory '$dir' not found."
        exit 1
    fi
done

# Compressing folders but don't include 'node_modules'
zip -q -r "$fdir/$fname" $dirs -x $excluded

dunstify "Backup" "Backup created successfully" -t 2000