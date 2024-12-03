#!/bin/sh
# Cài đặt môi trường homebrew

set -e

export BUNDLER_VERSION=2.2.25

# Install Homebrew
if type brew > /dev/null 2>&1; then
    echo 'homebrew already installed.'
    # brew update
else
    echo 'installing brew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install rbenv
if type rbenv > /dev/null 2>&1; then
    echo 'rbenv already installed.'
else
    brew install rbenv rbenv-communal-gems
    cat << EOS >> ~/.bash_profile
export PATH="~/.rbenv/shims:/usr/local/bin:\$PATH"
eval "\$(rbenv init -)"
EOS
    source ~/.bash_profile
fi

# Install Ruby
if [ "$(rbenv versions | grep $(rbenv local))" = "" ]; then
    echo 'Ruby installing.'
    rbenv install
else
    echo "ruby $(rbenv local) already installed."
fi

# Install Bundler
if [ "$(rbenv exec gem list bundler | grep $BUNDLER_VERSION)" = "" ]; then
    echo "Installing bundler."
    rbenv exec gem install bundler -v "$BUNDLER_VERSION"
else
    echo "Bundler $BUNDLER_VERSION already installed."
fi

# Install Mint
if [ "$(sh mint.sh --check)" = "installed" ]; then
    echo 'Mint already installed.'
else
    sh mint.sh --install
fi

# Copy post-checkout
WORKING_DIR=$(git rev-parse --show-toplevel)
cp -r $WORKING_DIR/set_environment/post-checkout $WORKING_DIR/.git/hooks
