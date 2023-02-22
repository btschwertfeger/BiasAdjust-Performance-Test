#!/usr/bin/env bash
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger
#
# This script can be used to install BiasAdjustCXX v1.8 from Zenodo

# download BiasAdjustCXX v1.8
yes | curl "https://zenodo.org/record/7652734/files/btschwertfeger/BiasAdjustCXX-v1.8.zip?download=1" > BiasAdjustCXX.zip

# unzip the file
unzip -qq BiasAdjustCXX.zip

# remove the zip archive
rm BiasAdjustCXX.zip

# rename project 
mv "btschwertfeger-BiasAdjustCXX-da4577c" BiasAdjustCXX 

cd BiasAdjustCXX

# create build directory
mkdir build && cd build 

# compile the BiasAdjustCXX tool
cmake .. && cmake --build .

cd ../../

exit 0
