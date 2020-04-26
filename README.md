# https://hub.docker.com/repository/docker/kkholst/stat

Base docker images for statistical modeling based on minideb.

https://cloud.docker.com/u/kkholst/repository/docker/kkholst/stat

## default
Derived from the 'base' image

R 4.0.0:
- Rcpp, RcppArmadillo, RcppEnsmallen

Python 3.7.3:
- numpy, pandas, scikit-build, scipy

Build chain:
- cmake, ninja, ccache

## base
R 4.0.0 with RcppEnsmallen and Python 3.7.3 (derived from the 'r' image).

## r
Minimal R image (version 4.0.0 with ICU, X11 disabled and without recommended libraries)
without the GNU C++ and Fortran compiler.

## python
Python 3.9.0a5 image.

------

## hugo
Minimal hugo 0.66.0-extended image.

## mlpack
- Armadillo 9.900
- Ensmallen
- MLPack 3

## rx

R image with X11 enabled.
