#!/usr/bin/env python3.10
# Copyright (C) 2023 Benjamin Thomas Schwertfeger   
# E-Mail: development@b-schwertfeger.de  
# Github: https://github.com/btschwertfeger

from typing import List, Tuple
import xarray as xr
import numpy as np
import sys

np.random.seed(0) # to reproduce the input_data


def get_hist_temp_for_lat(lat: int, time) -> List[float]:
    '''Returns a fake interval time series by latitude value'''
    return 273.15 - (
        lat * np.cos(
            2 * np.pi * time.dayofyear / 365
        ) + 2 * np.random.random_sample(
            (time.size,)
        ) + 273.15 + .1 * (
            time - time[0]
        ).days / 365
    )


def get_dataset(data, time, latitudes, longitudes) -> xr.Dataset:
    '''Returns a data set by data and time'''
    return xr.DataArray(
        data,
        dims=('lon', 'lat', 'time'),
        coords={
            'time': time, 
            'lat': latitudes, 
            'lon': longitudes
        },
    ).transpose('time', 'lat', 'lon').to_dataset(name='dummy')


def generate_and_save(n_lat: int, n_lon: int) -> None:   
    historical_time = xr.cftime_range('1971-01-01', '2000-12-31', freq='D', calendar='noleap')
    future_time = xr.cftime_range('2001-01-01', '2030-12-31', freq='D', calendar='noleap')

    latitudes = np.arange(n_lat)
    longitudes = np.arange(n_lon)

    some_data = [get_hist_temp_for_lat(val, historical_time) for val in latitudes]
    data = np.array([np.array(some_data) + np.random.rand() for x in range(len(longitudes))])
    del some_data

    get_dataset(data, historical_time, latitudes, longitudes).to_netcdf(f'input_data/obsh-{n_lon}x{n_lat}.nc')
    get_dataset(data - 2, historical_time, latitudes, longitudes).to_netcdf(f'input_data/simh-{n_lon}x{n_lat}.nc')
    get_dataset(data - 1, future_time, latitudes, longitudes).to_netcdf(f'input_data/simp-{n_lon}x{n_lat}.nc')


def main() -> None:
    for n_lat, n_lon in zip(np.arange(10,101,10), np.arange(10,101,10)):
        generate_and_save(n_lat,n_lon)

    # now we have a lot data sets like `obsh-10x10`, `obsh-20x20`, and also some like `simh-100x100´.


if __name__ == '__main__':
    main()
    sys.exit(0)

