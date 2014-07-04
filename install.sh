#!/usr/bin/sh

# comment `#include "matrix.h"` and add `typedef unsigned short uint16_T;`
# whenever needed in the *.c files)
cd stprtool/optimization
mkoctfile --mex qpssvm_mex.c qpssvmlib.c
mkoctfile --mex qpbsvm_mex.c qpbsvmlib.c
mkoctfile --mex gsmo_mex.c gsmolib.c
mkoctfile --mex gnnls_mex.c gnnlslib.c
mkoctfile --mex gmnp_mex.c gmnplib.c
cd ../svm
mkoctfile --mex smo_mex.c
mkoctfile --mex smo1d_mex.c
mkoctfile --mex svm2_mex.c ../kernels/kernel_fun.c
mkoctfile --mex bsvm2_mex.c ../kernels/kernel_fun.c
cd ../kernels
mkoctfile --mex kernel.c kernel_fun.c
mkoctfile --mex diagker.c kernel_fun.c
mkoctfile --mex kernelproj_mex.c kernel_fun.c
cd ../misc
mkoctfile --mex knnclass_mex.c
cd ../../
