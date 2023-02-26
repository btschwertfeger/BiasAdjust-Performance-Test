
<h1 style="center">Performance test of the <a href="https://zenodo.org/record/7652734" target="_blank">BiasAdjustCXX v1.8</a> command-line tool</h1>
<h3 style="centter"> ... and comparison to <a href="https://zenodo.org/record/7535677" target="blank">xclim v0.40.0</a> and <a href="https://zenodo.org/record/7652756" target="_blank">python-cmethods v0.6.1</a></h3> 

___


📍 Check out the results here: https://btschwertfeger.github.io/BiasAdjustCXX-Performance-Test/

📍 Check out the Notebook: https://github.com/btschwertfeger/BiasAdjustCXX-Performance-Test/blob/master/index.ipynb


<a name="introduction"></a>
# Introduction


There are many different tools for bias correction in climate data. One of these tools is `BiasAdjustCXX`, whose performance in terms of speed (execution time; i.e. the whole time between the program start until the end) will be examined in more detail. This notebook also serves as a guide for reproducing the results of these tests. Within this notebook scripts are called, which install the tool, generate test data and afterwards all procedures provided in `BiasAdjustCXX` (v1.8) are executed to adjust the generated data sets. 

To be able to compare this with something, the Python modules <a href="https://zenodo.org/record/7535677" target="blank">xclim</a> (v0.40.0) and <a href="https://zenodo.org/record/7652756" target="_blank">python-cmethods </a>(v0.6.1) are also used to measure their speed when applying the quantile mapping (QM) for `python-cmethods` and the quantile delta mapping (QDM) for both. Since all tools bring a variety of methods with them, but these differ both in terms of implementation and approach, only QM and QDM are tested here for `python-cmethods`. For the `xclim` module, only QDM is tested. 

____
<a name="tools"></a>
## Tools

Comparison of the speed performance of the bias correction tools: 
- [BiasAdjustCXX v1.8](https://zenodo.org/record/7652734) (C++ command-line tool)
- [python-cmethods v0.6.1](https://zenodo.org/record/7652756) (Python3 module)
- [xclim](https://zenodo.org/record/7535677) (Python3 module)

____

<a name="test-env"></a>
## Test environment and approach
This tests was run on MacBook Pro 13-inch 2017 (tests run in February of 2023)

with:

* Processor: 2.3 GHz Dual-Core Intel Core i5
* L2-Cache (per core): 256 KB
* L3-Cache: 4 MB
* Hyper-Threading Technology: enabled
* RAM: 8 GB 2133 MHz LPDDR3
* OS: MacOS Ventura 13.2.1
* Disk: 512 GB APPLE SSD AP0512J

All tests have been executed on the same machine. The scripts `scripts/test_performance_*.sh` were used for this purpose. The adjustments are executed using a minimal setup for all tools. The input data sets were randomly generated, this can be reproduced using the script `scripts/generate_test_data.py`. All datasets have exactly 10950 float values per grid cell, so this is comparable to 30 years of daily temperature values. A seed was set so that re-execution would generate the same data. 

All methods provided in the BiasAdjustCXX tool are tested. For `python-cmthods`, the corrections are only performed for the QM and QDM. For `xclim` only the QDM is used, because this is the only method with a comparable implementation in `BiasAdjustCXX` and `python-cmethods`. All methods are given the same parameters, that is, they are given the same input data sets and all distribution-based methods are given the value of 250 for the number of quantiles to be considered.

Data sets are generated, which contain a grid of 10x10, 20x20, 30x30, ..., 100x100 with 10950 values per grid cell. Since especially with the Python modules the time to load, prepare and correct a data set varies strongly despite seemingly equal starting-/preconditions, the data sets are corrected multiple times per tool. This provides a better overview of the outliers and also makes it possible to map an average value.

It has been found that the python modules have difficulty processing large datasets, for this reason only datasets with a resolution up to 60x60 are tested for these python modules. 

`BiasAdjustCXX` also offers the computation using multiple threads. This is als tested here.

#### Notes:
* In this tests, the data sets with a grid of 100x100 are about 836 MB in size ($T_{obs,h}$, $T_{sim,h}$ and $T_{sim,p}$ together thus 2.508 GB). A dataset with a resolution of 500x500 would therefore be 25 times larger ($100 \cdot 100 = 10000 \rightarrow 500 \cdot 500 = 250000$), i.e. 62.5 GB in total. Since I don't have this capacity at the time of writing, I don't currently have access to more powerful machines, and I'm making this supplement within 3 weeks besides of my regular work, the largest grid examined here is 100x100.
* The results of all tests can be foudn in the `performance_results` dirctory.
____
<a name="requirements"></a>
## Requirements

To run the python modules, python==3.10.18 is required, since this is the latest version, that `xclim` supports. It is recommended to create a virtual environment and install the requirements like this:

```bash
python3 -m venv test_performance_venv
source test_performance_venv/bin/activate
python3 -m pip install -r requirements.txt
``` 

For the compilation of [BiasAdjustCXX v1.8](https://zenodo.org/record/7652734) the following libraries and tools are needed:
* NetCDF-4 C library ([How to install NetCDF-4 C](https://docs.geoserver.org/stable/en/user/extensions/netcdf-out/nc4.html))
* CMake v3.10+ ([How to install CMake](https://cmake.org/install/))

The compilation can be done using:

Compilation:

```bash
mkdir build && cd build
cmake .. && cmake --build .
```
(... or see the README.md of [BiasAdjustCXX v1.8](https://zenodo.org/record/7652734))


____
<a name="disclaimer"></a>
## Disclaimer

* The scripts contained in this project/repository were created by Benjamin T. Schwertfeger in February 2023 and serve as a supplement to a manuscript introducing the command-line tool <a href="https://zenodo.org/record/7652734" target="_blank">BiasAdjustCXX v1.8</a>. This manuscript was submitted to the journal [SoftwareX](https://www.sciencedirect.com/journal/softwarex) in January 2023. 

* Errors and inaccuracies can happen. The tests performed here have been executed with the best of conscience. However, it is requested that you do not execute any of these scripts without understanding their contents. The author assumes no liability for errors, data loss, exploits or other damages caused by this code. 

____

<a name="toc"></a>
## Table of contents 
(https://btschwertfeger.github.io/BiasAdjustCXX-Performance-Test/)

1. Download and compilation BiasAdjustCXX v1.8
2. Generate test data sets
3. Run the performance tests for BiasAdjustCXX v1.8, xclim v0.40.0 and python-cmethods v0.6.1
4. Evaluation of the results
    
    4.1 Results of BiasAdjustCXX v1.8 (DM, LS, VS, QM, and QDM)


    4.2 Results of xclim v0.40.0 (QDM)
    
    
    4.3 Results of python-cmethods v0.6.1 (QM and QDM)
    
    
    4.4 Comparison of the execution time of QDM

5. Conclusion](#conclusion)
___
<a name="abbrev"></a>
## Abbreviations

|Phrase|Definitiion|
|-----|------|
|DM|Delta Method|
|LS|Linear Scaling|
|VS|Variance Scaling|
|QM|Quantile Mapping|
|QDM|Quantile Delta Mapping|

____

<a name="references"></a>

## References

For further information regarding the mathematical basis of the correction procedures of `BiasAdjustCXX` I refer to the following articles:

* Linear Scaling and Variance Scaling based on: Teutschbein, Claudia and Seibert, Jan (2012) Bias correction of regional climate model simulations for hydrological climate-change impact studies: Review and evaluation of different methods (https://doi.org/10.1016/j.jhydrol.2012.05.052)
* Delta Method based on: Beyer, R. and Krapp, M. and Manica, A. (2020): An empirical evaluation of bias correction methods for palaeoclimate simulations (https://doi.org/10.5194/cp-16-1493-2020)
* Quantile Mapping based on: Alex J. Cannon and Stephen R. Sobie and Trevor Q. Murdock Bias Correction of GCM Precipitation by Quantile Mapping: How Well Do Methods Preserve Changes in Quantiles and Extremes? (https://doi.org/10.1175/JCLI-D-14-00754.1)
* Quantile Delta Mapping based on: Tong, Y., Gao, X., Han, Z. et al. Bias correction of temperature and precipitation over China for RCM simulations using the QM and QDM methods. Clim Dyn 57, 1425–1443 (2021). (https://doi.org/10.1007/s00382-020-05447-4)
