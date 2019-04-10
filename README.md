# rdbase

Base docker images for statistical modeling

https://cloud.docker.com/u/kkholst/repository/docker/kkholst/rdbase

## r
Minimal R image (ICU, X11 disabled and without recommended libraries).
Includes armadillo C++ library

## mlpack
- Ensmallen 
- Armadillo 9.3
- MLPack 3
-  


## rpostgres

- R (3.5.1)
- python (3.6.7)
- gcc (8.2.0), g++, gfortran
- openJDK 8

R-packages: 
- RJDBC
- RSQLite
- RPostgreSQL
- data.table
- prodlim
- mets (installed from latest master branch)
- lava (installed from latest master branch)

## rx

Like rpostgres but X11 enabled.

## forecast

Based on 'rx' with R-packages for time series modeling
	- zoo
- xts
- forecast

## basex

Based on 'rx'. 

Numerical and ML libraries:
- armadillo 9.200
- mlpack 3.0.4
- dmlc
- boost

R-packages (ML)
- caret
- e1071
- mboost
- gbm
- randomForest
- quantreg
- quantregForest
- elasticnet

R-packages (statistics)
- mets
- lme4
- lava

R packages (time series):
- xts
- zoo
- forecast
- lubridate
- ISOweek

R packages (database)
- RPostgreSQL
- RSQLite
- RJDBC


