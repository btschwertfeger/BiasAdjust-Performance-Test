import xarray as xr
from cmethods.CMethods import CMethods
import sys


def main() -> None:
    
    resolution = sys.argv[1]
    method = sys.argv[2]

    # load data
    obsh = xr.open_dataset(f'input_data/obsh-{resolution}.nc')
    simh = xr.open_dataset(f'input_data/simh-{resolution}.nc')
    simp = xr.open_dataset(f'input_data/simp-{resolution}.nc')
    
    cm = CMethods()
    
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
