#!/usr/bin/env bash
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger
#
# Only Quantile Delta Mapping and Quantile Mapping will be tested, because the other 
# methods have a slighly different implementation than in BiasAdjustCXX

mkdir -p bc_output

python3 -m venv test_performance_venv
source test_performance_venv/bin/activate
python3 -m pip install -r requirements.txt

TABLE_HEADER="resolution,time (seconds)"

for method in "quantile_mapping" "quantile_delta_mapping"; do
    perf_fname="performance_results/performance_python-cmethods_method-$method.csv"
    echo $TABLE_HEADER >> $perf_fname
    
    for i in `seq 1 10`; do 
        for resolution in "10x10" "20x20" "30x30" "40x40" "50x50" "60x60"; do
            echo "$i: $resolution"
            START=$(date +%s)
            python3 scripts/run_python-cmethods.py $resolution $method
            END=$(date +%s)
            
            DIFF=$(echo "$END - $START" | bc)
            echo "$resolution,$DIFF" >> $perf_fname

            rm bc_output/*
        done
    done
done

exit 0

