#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ $(id -u) -ne 0 ]]; then
  echo "This script requires sudo privileges"
  exit 1
fi

HOME_FONT="$HOME/.fonts"
MOST_DISTROS="/usr/share/fonts"

if test -e $MOST_DISTROS; then
  FONT_PATH=$MOST_DISTROS
else
  FONT_PATH=$HOME_FONT
fi

if [ -d "$FONT_PATH" ]; then
  # flush stdin
  while read -r -t 0; do read -r; done
  read -p "Font Directory already exists, continue? [y/N] " -n 1 -r

  if [[ $REPLY == "" ]]; then
    exit 0
  elif [[ $REPLY =~ ^[Nn]$ ]]; then
    exit 0
  fi
fi

echo -e "\nFonts will be installed in: "$FONT_PATH
read -p "Continue with installation? [Y/n] " -n 1 -r

if [[ $REPLY =~ ^[Nn]$ ]]; then
  exit 0
fi

if [ ! -d "$FONT_PATH" ]; then
  echo "Creating Font Directory..."
  mkdir $FONT_PATH
fi

echo "Installing Fonts..."
cp *.ttf $FONT_PATH
cp *.TTF $FONT_PATH
echo "Fixing Permissions..."
chmod 644 $FONT_PATH/*

echo "Rebuilding Font Cache..."
if ! fc-cache -vfs; then
  echo "Failed to rebuild font cache."
  exit 1
fi

echo "Installation Finished."

exit 0
