# Test environments
## local 
* macOS Mojave 10.14.6
* R version 3.6.1 (2019-07-05)

## R CMD check results
* There were no ERRORs or WARNINGs, or NOTES 

## travis-ci
* R version 3.6.2 (2017-01-27)
* Platform: x86_64-pc-linux-gnu (64-bit)
* Running under: Ubuntu 16.04.6 LTS
* passing

## ci.appveyor
* R version 3.6.3 Patched (2020-02-29 r77919)
* Platform: x86_64-w64-mingw32/x64 (64-bit)
* Running under: Windows Server 2012 R2 x64 (build 9600)
* passing

## R-hub builder
* Build ID:	suddengains_0.4.2.tar.gz-ab122fe2d5de451dab248c624bb811b3
* Platform:	Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* checking package dependencies ... ERROR
* Package required but not available: 'ggplot2'

## winbuilder
* https://win-builder.r-project.org/5JY4Y68182H0
* Status: OK
* R version 3.6.3 (2020-02-29)

* https://win-builder.r-project.org/Iq6fgrEMhvz9
* Status: 1 NOTE

# Resubmission
This is a resubmission.

* I have removed the following non-portable file paths:
  * suddengains/docs/articles/suddengains-tutorial_files/dt-ext-fixedcolumns-1.10.19/css/fixedColumns.dataTables.min.css
  * suddengains/docs/articles/suddengains-tutorial_files/dt-ext-fixedcolumns-1.10.19/js/dataTables.fixedColumns.min.js
  * suddengains/docs/articles/suddengains-tutorial_files/dt-ext-fixedcolumns-1.10.20/css/fixedColumns.dataTables.min.css
  * suddengains/docs/articles/suddengains-tutorial_files/dt-ext-fixedcolumns-1.10.20/js/dataTables.fixedColumns.min.js
* Removed the non-standard file/directory found at top level:
    'docs'

