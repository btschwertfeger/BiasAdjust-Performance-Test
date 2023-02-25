#!/usr/bin/env python3.10
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger

import sys
from xarray import open_dataset
from cmethods.CMethods import CMethods

def main() -> None:
    
    resolution = sys.argv[1]
    method = sys.argv[2] 

    # load data
    obsh = open_dataset(f'input_data/obsh-{resolution}.nc')
    simh = open_dataset(f'input_data/simh-{resolution}.nc')
    simp = open_dataset(f'input_data/simp-{resolution}.nc')
    
    cm = CMethods()

    # start computation
    result = cm.adjust_3d(
        method=method,
        obs=obsh['dummy'],
        simh=simh['dummy'],
        simp=simp['dummy'],
        n_quantiles=250, # will be ignored if not used by the function
        kind='+'
    )  

    result.to_netcdf(f'bc_output/pycmethods-{method}-{resolution}.nc')
    sys.exit(0)
    

if __name__ == '__main__':
    main()
