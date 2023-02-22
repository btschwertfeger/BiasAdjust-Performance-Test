import xarray as xr
from xclim.sdba.adjustment import QuantileDeltaMapping
import sys


def main() -> None:
    
    resolution = sys.argv[1]
    
    # load data
    obsh = xr.open_dataset(f'input_data/obsh-{resolution}.nc')
    simh = xr.open_dataset(f'input_data/simh-{resolution}.nc')
    simp = xr.open_dataset(f'input_data/simp-{resolution}.nc')
 
    result = simp.load().copy(deep=True).transpose('lat', 'lon', 'time')

    # units need to be assigned to work with xclim.sdba
    obsh = obsh['dummy'].assign_attrs({'units': 'C'})
    simh = simh['dummy'].assign_attrs({'units': 'C'})
    simp = simp['dummy'].assign_attrs({'units': 'C'})

    for lat in range(len(obsh.lat)):
        for lon in range(len(obsh.lon)):
            result['dummy'][lat,lon] = QuantileDeltaMapping.train(
                obsh[:,lat,lon],
                simh[:,lat,lon],
                nquantiles=250,
                kind='+'
            ).adjust(simp[:,lat,lon])

    result.transpose('time', 'lat', 'lon').to_netcdf(f'bc_output/xclim-qdm-{resolution}.nc')
    sys.exit(0)
    

if __name__ == '__main__':
    main()
