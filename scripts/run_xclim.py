#!/usr/bin/env python3.10
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger

from xarray import open_dataset
from xclim.sdba.adjustment import QuantileDeltaMapping
import sys


def main() -> None:
    
    resolution = sys.argv[1]
    
    # load data
    obsh = open_dataset(f'input_data/obsh-{resolution}.nc')
    simh = open_dataset(f'input_data/simh-{resolution}.nc')
    simp = open_dataset(f'input_data/simp-{resolution}.nc')
    
    # units need to be assigned to work with xclim.sdba
    obsh = obsh['dummy'].assign_attrs({'units': 'C'})
    simh = simh['dummy'].assign_attrs({'units': 'C'})
    simp = simp['dummy'].assign_attrs({'units': 'C'})

    # copy to maintain grid, lats, lons, time, attrs
    result = simp.copy(deep=True)

    for lat in range(len(obsh.lat)):
        for lon in range(len(obsh.lon)):
            result[:,lat,lon] = QuantileDeltaMapping.train(
                obsh[:,lat,lon],
                simh[:,lat,lon],
                nquantiles=250,
                kind='+'
            ).adjust(simp[:,lat,lon])

    result.to_netcdf(f'bc_output/xclim-qdm-{resolution}.nc')
    

if __name__ == '__main__':
    main()
    sys.exit(0)
