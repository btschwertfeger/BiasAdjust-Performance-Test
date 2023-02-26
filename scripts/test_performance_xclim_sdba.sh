#!/usr/bin/env bash
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger
#
# Only Quantile Delta Mapping will be tested, because running bias corrections in python 
# takes to much time and the other methods have a slighly different implementation than in BiasAdjustCXX

mkdir -p bc_output performance_results

perf_fname="performance_results/performance_xclim_method-quantile_delta_mapping.csv"
TABLE_HEADER="resolution,time (seconds)"
echo $TABLE_HEADER >> $perf_fname

python3 -m venv test_performance_venv
source test_performance_venv/bin/activate
python3 -m pip install -r requirements.txt

for i in `seq 1 5`; do 
    for resolution in "10x10" "20x20" "30x30" "40x40" "50x50" "60x60"; do
        echo "$i: $resolution" 
        START=$(date +%s)
        python3 scripts/run_xclim.py $resolution
        END=$(date +%s)
        
        DIFF=$(echo "$END - $START" | bc)
        echo "$resolution,$DIFF" >> $perf_fname
        echo "${DIFF}s"
        rm bc_output/*
    done
done

exit 0

