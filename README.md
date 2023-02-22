# BiasAdjustCXX performance tests (+ comparison to other bias adjustment tools)

Comparison of the performance of the bias correction tools: 
- [BiasAdjustCXX v1.8](https://zenodo.org/record/7652734) (C++ command-line tool)
- [python-cmethods v0.6.1](https://zenodo.org/record/7652756) (python3 module)
- [xclim](https://zenodo.org/record/7535677) (python3 module)


This repository is all about the `main.ipynb`-notebook which can be found in root directory. Here, all required steps are described, listed and shown on how to execute the named tools. Also results regarding the execution time are visualized.

_____
## Test system and environment

This tests was run on MacBook Pro 13-inch 2017 (19th and 20th February of 2023)

with:
- Processor: 2.3 GHz Dual-Core Intel Core i5
- RAM: 8 GB 2133 MHz LPDDR3
- OS: MacOS Ventura 13.2.1


____
## Tools and requirements

### Tool 1: [BiasAdjustCXX v1.8](https://zenodo.org/record/7652734)

Download the tool from [Zenodo](https://zenodo.org/record/7652734/files/btschwertfeger/BiasAdjustCXX-v1.8.zip?download=1) or directly from [Github](https://github.com/btschwertfeger/BiasAdjustCXX/archive/refs/tags/v1.8.zip)

```bash
mkdir build && cd build
cmake .. && cmake --build .
```
#### Required libraries and tools
- NetCDF-4 C library ([How to install NetCDF-4 C](https://docs.geoserver.org/stable/en/user/extensions/netcdf-out/nc4.html))
- CMake v3.10+ ([How to install CMake](https://cmake.org/install/))

### Tools 2 & 3: [python-cmethods v0.6.1](https://zenodo.org/record/7652756) and [xclim](https://zenodo.org/record/7535677)

To run the performance tests, python==3.10.18 is required, since this is the newest version, that `xclim` supports.

Here is some example on how to create a virtual environment, how to activate it and how to install the requirements:

```bash
python3 -m venv test_performance_venv
source test_performance_venv/bin/activate
python3 -m pip install -r requirements.txt
```
