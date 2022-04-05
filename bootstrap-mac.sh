#!/usr/bin/env bash
########
# bootstrap-mac.sh
#
# The purpose of this script is to set up a development environment. It is designed to be idempotent, so if you
# already have a functioning setup, it should do nothing

# BEFORE YOU START
# Ensure that you have the latest version of OSX and Xcode installed. Older versions may not work, e.g. because Homebrew and Node require a certain Xcode version
# Ensure you've set up your github ssh keys, or the git clone step will fail

# You'll also want to install other things that aren't covered in this script, like Android Studio and whatever IDE you prefer (e.g. VSCode or WebStorm)

# Xcode
if ! [ -x "$(command -v xcode-select)" ]; then
  echo "Couldn't find xcode-select! Please make sure you are on a mac with Xcode installed" >&2
  exit 1
fi
xcode-select --install # does nothing if the tools are already installed

# Homebrew
if ! [ -x "$(command -v brew)" ]; then
  echo "Homebrew does not exist, installing..."
  # see https://docs.brew.sh/Installation for help
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
else
  echo "Homebrew already exists, skipping"
fi

# Node
# It's recommended to use homebrew to install node, rather than nvm, as the react-native build process sometimes fails to find the right version of node with nvm
if ! [ -x "$(command -v node)" ]; then
  echo "Node does not exist, installing..."
  brew install node@16 || exit 1
  # this command will output some things that you will need to add to your .zshrc file, please do that
else
  echo "Node already exists, skipping"
fi

# Docker for Mac
if ! [ -x "$(command -v docker)" ]; then
  echo "Docker does not exist, installing..."
  brew install homebrew/cask/docker || exit 1
else
  echo "Docker already exists, skipping"
fi

# Postgres
if ! [ -x "$(command -v psql)" ]; then
  echo "Postgres does not exist, installing..."
  brew install postgres || exit 1
else
  echo "Postgres already exists, skipping"
fi

# Media command line tools, dev tools
# For extra installation instructions see:
# https://github.com/git-lfs/git-lfs/wiki/Installation
brew install ffmpeg imagemagick watchman git-lfs coreutils

# Project directory
mkdir -p ~/Projects
cd ~/Projects

# Repo
if ! [[ -d "~/Projects/blueheart/.git" ]]
then
    echo "A repo already exists at ~/Projects/blueheart/ so skipping git clone"
else
  git clone git@github.com:blueheartio/blueheart.git || exit 1
fi
cd blueheart

# Yarn install
yarn install || exit 1
yarn tsc || exit 1

# Done!
echo "✨✨✨"
echo "Dependencies are installed!"
echo "cd ~/Projects/blueheart"
echo "Please check the README.md to see what you can do next"
