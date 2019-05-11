## Resubmission
This is a resubmission. 
I have tried to reproduce the package dependency error "Package required but not available: 'readr'" locally, on three R-hub platforms, and on travis-ci and ci.appveyor. See more information below. 
In this version I have also updated the minimum version of dependencies in the DESCRIPTION file.

## Test environments
* local OS X install, R 3.5.3
* Ubuntu 14.04.5 LTS (on travis-ci), R 3.5.3
* Windows Server 2012 R2 x64 (build 9600) (on ci.appveyor), R 3.5.3

## CRAN checks on R-hub
### Platform:	Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* Build ID:	suddengains_0.2.0.tar.gz-3761be993ca348359bbf95920b8b5344
* Build time:	3 minutes 49.3 seconds
* suddengains 0.2.0: OK

### Platform:	Fedora Linux, R-devel, clang, gfortran
* Build ID:	suddengains_0.2.0.tar.gz-a146620cd9214438bff132d67ff7da85
* Build time:	28 minutes 21.3 seconds
* suddengains 0.2.0: OK

### Platform:	Ubuntu Linux 16.04 LTS, R-release, GCC
* Build ID:  suddengains_0.2.0.tar.gz-849222ef4e434b64aa404ce01b370cb8
* Build time:	22 minutes 30.8 seconds
* suddengains 0.2.0: OK

## R CMD check results
* There were no ERRORs or WARNINGs or NOTES 
