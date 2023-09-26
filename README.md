# https://hub.docker.com/repository/docker/kkholst/stat

Base docker images for statistical modeling based on minideb.

https://cloud.docker.com/u/kkholst/repository/docker/kkholst/stat

## latest
Tag for latest =default= image

## default
Derived from the 'base' image

R 4.2.1:
- Rcpp, RcppArmadillo, RcppEnsmallen, IRkernel

Python 3.11.2-1:
- numpy, pandas, scikit-build, pandas, scipy, jupyter-lab

Build chain:
- cmake, ninja, ccache

## base
R 4.2.1 with RcppEnsmallen and Python 3.11.2-1 (derived from the 'r' image).

## r
Minimal R image (version 4.2.1 with ICU, X11 disabled and without recommended libraries)

