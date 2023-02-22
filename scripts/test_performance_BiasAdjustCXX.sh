#!/usr/bin/env bash
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger


INPUT_DIR="input_data"
BiasAdjustCXX="BiasAdjustCXX/build/BiasAdjustCXX"

mkdir -p bc_output

# get files
OBSH_FILES=($INPUT_DIR/obsh*)
SIMH_FILES=($INPUT_DIR/simh*)
SIMP_FILES=($INPUT_DIR/simp*)

TABLE_HEADER="resolution,jobs,time (seconds)"
# iterate over the files to run the adjustment

variable="dummy"
kind="+"

# iterate over the scaling-based methods
for method in  "delta_method"; do #"linear_scaling" "variance_scaling"
    
    # execute the program with 1..4 parallel jobs
    perf_fname="performance_BiasAdjustCXX_method-${method}.csv"
    echo $TABLE_HEADER > $perf_fname

    for jobs in {1..4}; do

        # for every resoulution
        for resolution in ${!OBSH_FILES[*]}; do
            START=$(date +%s)
            $BiasAdjustCXX                          \
                --ref "${OBSH_FILES[resolution]}"   \
                --contr "${SIMH_FILES[resolution]}" \
                --scen "${SIMP_FILES[resolution]}"  \
                -o "bc_output/${variable}_${method}_kind${kind}${resolution}" \
                -v "dummy"                          \
                -k "+"                              \
                -m $method                          \
                -p $jobs
            
            END=$(date +%s)
            DIFF=$(echo "$END - $START" | bc)
            resolution=`echo "${OBSH_FILES[resolution]}" | sed 's/input_data\/obsh-//' | sed 's/.nc//'`
            echo "$resolution,$jobs,$DIFF" >> $perf_fname
            rm bc_output/*
        done
    done
done

for method in "quantile_mapping" "quantile_delta_mapping"; do
    
    # execute the program with 1..4 parallel jobs
    perf_fname="performance_BiasAdjustCXX_method-${method}.csv"
    echo $TABLE_HEADER > $perf_fname

    for jobs in {1..4}; do

        # for every resoulution
        for resolution in ${!OBSH_FILES[*]}; do
            START=$(date +%s)
            $BiasAdjustCXX                          \
                --ref "${OBSH_FILES[resolution]}"   \
                --contr "${SIMH_FILES[resolution]}" \
                --scen "${SIMP_FILES[resolution]}"  \
                -o "bc_output/${variable}_${method}_kind${kind}${resolution}" \
                -v "dummy"                          \
                -k "+"                              \
                -m $method                          \
                -q 250                              \
                -p $jobs
            
            END=$(date +%s)
            DIFF=$(echo "$END - $START" | bc)
            resolution=`echo "${OBSH_FILES[resolution]}" | sed 's/input_data\/obsh-//' | sed 's/.nc//'`
            echo "$resolution,$jobs,$DIFF" >> $perf_fname
            rm bc_output/*
        done
    done
done

rm -rf bc_output

exit 0
