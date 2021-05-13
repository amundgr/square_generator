#!/bin/bash

# My hacky script for bypassing the fact that I do not understand
# how to not have a flat project structure when using apio.
# It literary just moves the relevant files up to the root folder when
# needed, moves generated files to its respective folders and cleans
# the root folder when done. It works, I am happy.  

if [ -d "simulation" ]; then
    mkdir simulation
fi

if [ -d "synthesis" ]; then
    mkdir synthesis
fi

if [ "$1" = "sim" ]; then
    cp hdl/*.v .
    cp hdl/modules/*.v .
    if [ -z $2 ]; then
        cp test/*.v .
    else
        cp $2 .
    fi
    apio sim
    rm *.v
    mv *.vcd simulation
    mv *.out simulation
elif [ "$1" = "build" ]; then
    cp hdl/*.v .
    cp hdl/modules/*.v .
    apio build
    mv hardware.* synthesis
    rm *.v
elif [ "$1" = "alias" ]; then
    alias sim="./wrapper.sh sim"
    alias build="./wrapper.sh build"
else
    echo "Unknown argument..."
fi
