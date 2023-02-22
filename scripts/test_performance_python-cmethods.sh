#!/usr/bin/env bash
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger
#
# Only Quantile Delta Mapping and Quantile Mapping will be tested, because running bias corrections
# in python takes to much time.
# This is only intended to demonstrate the better performance of correction using a C++ implementation

mkdir -p bc_output

python3 -m venv test_performance_venv
source test_performance_venv/bin/activate
python3 -m pip install -r requirements.txt

for method in "quantile_mapping" "quantile_delta_mapping"; do
    perf_fname="performance_python-cmethods_$method.csv"
    for resolution in "10x10" "20x20" "30x30" "40x40" "50x50" "60x60"; do
        echo $resolution
        START=$(date +%s)
        python3 scripts/run_python-cmethods.py $resolution $method
        END=$(date +%s)
        
        DIFF=$(echo "$END - $START" | bc)
        echo "$resolution,$DIFF" >> $perf_fname

        rm bc_output/*
    done
done

exit 0

