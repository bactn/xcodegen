#!/bin/bash

MINT_INSTALL_DIR="mint"
MINT_PATH_AT_RUN="mint/lib" # Path from this script
MINT_LINK_PATH_AT_RUN="mint/bin" # Path from this script

MINT_PATH_AT_INSTALL="../lib"
MINT_LINK_PATH_AT_INSTALL="../bin"
MINT_PATH_FROM_MINT_LINK_PATH="../lib"

ARGUMENTS="$@"

ScriptPath=$(dirname ${BASH_SOURCE:-$0})

function usage() {
    cat <<EOM
    This script run or install Mint in project directory.
    
    Usage: sh ${0} [options]
    
    Options:
        -h,--help       Display this help
        -i,--install    Install Mint in project directory
        -c,--check      Check if Mint installed in project directory
        -u,--update     Update Mint
EOM
    exit 2;
}

function install() {
    if [ "$ScriptPath" != "." ]; then
        echo "Error: Installing Mint should be run in the same directory as script(mint.sh)."
        exit 1
    fi
    
    mkdir -p $MINT_INSTALL_DIR
    cd $MINT_INSTALL_DIR
    git clone https://github.com/yonaskolb/Mint.git
    cd Mint
    MINT_PATH=$MINT_PATH_AT_INSTALL MINT_LINK_PATH=$MINT_LINK_PATH_AT_INSTALL swift run mint install yonaskolb/mint
    cd $MINT_LINK_PATH_AT_INSTALL
    mint_bin_path=$(find ${MINT_PATH_FROM_MINT_LINK_PATH}/packages/github.com_yonaskolb_mint/build/*/mint)
    ln -sf $mint_bin_path mint
    cd ../
    rm -rf Mint
    cd ../
    exit 0;
}

function run() {
    local mintPath="${ScriptPath}/${MINT_PATH_AT_RUN}"
    local mintLinkPath="${ScriptPath}/${MINT_LINK_PATH_AT_RUN}"
    local mintLink="${ScriptPath}/${MINT_LINK_PATH_AT_RUN}/mint"
    MINT_PATH=$mintPath MINT_LINK_PATH=$mintLinkPath eval $mintLink $ARGUMENTS
    exit 0;
}

function check() {
    local mintLink="${ScriptPath}/${MINT_LINK_PATH_AT_RUN}/mint"
    if type $mintLink > /dev/null 2>&1; then
        echo "installed"
    else
        echo "not installed"
    fi
    exit 0;
}

function update() {
    if [ "$ScriptPath" != "." ]; then
        echo "Error: Updating Mint should be run in the same directory as script(mint.sh)."
        exit 1
    fi
    
    local mintDirPath="${MINT_INSTALL_DIR}/Mint"
    if [ -d $mintDirPath ]; then
        rm -rf $mintDirPath
        install
    else
        install
    fi
    exit 0;
}

if [ ${#@} -eq 1 ]; then
    if [ "${@#"-h"}" = "" ] || [ "${@#"--help"}" = "" ]; then
        usage
    fi

    if [ "${@#"-i"}" = "" ] || [ "${@#"--install"}" = "" ]; then
        install
    fi

    if [ "${@#"-c"}" = "" ] || [ "${@#"--check"}" = "" ]; then
        check
    fi
    
    if [ "${@#"-u"}" = "" ] || [ "${@#"--update"}" = "" ]; then
        update
    fi
fi

run
