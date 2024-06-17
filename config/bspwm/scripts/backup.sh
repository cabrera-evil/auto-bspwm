#!/bin/bash

# Backup file name
fdir=~/Documents/Backups
fname=bk-$(date +%Y-%m-%d).zip

# List of important directories
dirs='git npm work server Documents Pictures'

# List of excluded files
excluded="*/node_modules/*" -x "*.zip"

# Compressing folders but don't include 'node_modules'
zip -q -r $fdir/$fname $dirs -x $excluded
