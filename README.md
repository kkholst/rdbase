# https://hub.docker.com/repository/docker/kkholst/stat

Base docker images for statistical modeling based on Alpine 3.11.3.

https://cloud.docker.com/u/kkholst/repository/docker/kkholst/stat

## default
Derived from the 'base' image

R 3.6.3:
- Rcpp
- RcppArmadillo
- RcppEnsmallen 

Python 3.8:
- numpy
- pandas
- patsy
- scikit-build
- scipy
- statsmodels

Build chain and development tools:
- tmux
- mg
- git
- ninja
- cmake
- ccache

## base
R 3.6.3 with RcppEnsmallen and Python 3.8 (derived from the 'r' image).

## r
Minimal R image (version 3.6.3 with ICU, X11 disabled and without recommended libraries)
without the GNU C++ and Fortran compiler.

## python
Minimal python 3.8 image.

------

## hugo
Minimal hugo 0.66.0-extended image.

## mlpack
- Armadillo 9.900
- Ensmallen 
- MLPack 3

## rx

R image with X11 enabled.

