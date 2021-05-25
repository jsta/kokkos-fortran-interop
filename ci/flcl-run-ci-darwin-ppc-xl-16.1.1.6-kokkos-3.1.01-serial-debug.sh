#!/bin/tcsh
setenv CI_SEP -
setenv CI_BUILD_TYPE debug
setenv CI_BUILD_SUFFIX build
setenv CI_INSTALL_SUFFIX install
setenv CI_MACHINE_ARCH ppc
setenv CI_COMPILER_FAMILY xl
setenv CI_COMPILER_VER 16.1.1.6
setenv CI_COMPILER_NAME $CI_COMPILER_FAMILY$CI_SEP$CI_COMPILER_VER$CI_SEP
setenv CI_CUDA_PREFIX cuda
setenv CI_CUDA_VER 
setenv CI_CUDA_NAME 
setenv CI_KOKKOS_PREFIX kokkos
setenv CI_KOKKOS_VER 3.1.01
setenv CI_KOKKOS_BACKEND serial
setenv CI_KOKKOS_NAME $CI_KOKKOS_PREFIX$CI_SEP$CI_KOKKOS_VER$CI_SEP$CI_KOKKOS_BACKEND$CI_SEP$CI_BUILD_TYPE
setenv CI_KOKKOS_PATH_PREFIX /home/$USER/kt
setenv CI_KOKKOS_INSTALL_DIR $CI_KOKKOS_PATH_PREFIX/$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME
setenv CI_KOKKOS_BUILD_DIR $CI_KOKKOS_INSTALL_DIR$CI_SEP$CI_BUILD_SUFFIX
setenv CI_FLCL_PREFIX flcl
setenv CI_FLCL_PATH_PREFIX /home/$USER/kokkos-fortran-interop
setenv CI_FLCL_CI_PATH_PREFIX $CI_FLCL_PATH_PREFIX/ci
setenv CI_FLCL_KOKKOS_PATH $CI_KOKKOS_INSTALL_DIR/lib64/cmake/Kokkos
setenv CI_FLCL_BUILD_DIR $CI_FLCL_CI_PATH_PREFIX/$CI_FLCL_PREFIX$CI_SEP$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME$CI_SEP$CI_BUILD_SUFFIX
setenv CI_FLCL_INSTALL_DIR $CI_FLCL_CI_PATH_PREFIX/$CI_FLCL_PREFIX$CI_SEP$CI_MACHINE_ARCH$CI_SEP$CI_COMPILER_NAME$CI_CUDA_NAME$CI_KOKKOS_NAME$CI_SEP$CI_INSTALL_SUFFIX
rm -rf $CI_FLCL_INSTALL_DIR
rm -rf $CI_FLCL_BUILD_DIR
mkdir -p $CI_FLCL_INSTALL_DIR
mkdir -p $CI_FLCL_BUILD_DIR
module load cmake/3.19.2
module load gcc/7.4.0
module load ibm/xlc-16.1.1.6-xlf-16.1.1.6
setenv LD_LIBRARY_PATH /projects/opt/ppc64le/ibm/xlf-16.1.1.6/lib:$LD_LIBRARY_PATH
setenv CC xlc_r
setenv CXX xlc++_r
setenv F77 xlf_r
setenv FC xlf_r
cd $CI_FLCL_BUILD_DIR
cmake $CI_FLCL_PATH_PREFIX\
    -DKokkos_DIR=$CI_FLCL_KOKKOS_PATH \
    -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON -DBUILD_EXAMPLES=ON \
    -DCMAKE_INSTALL_PREFIX=$CI_FLCL_INSTALL_DIR \
    -DCMAKE_Fortran_COMPILER_ARG1="-F/projects/opt/ppc64le/ibm/xlf-16.1.1.6/xlf/16.1.1/etc/xlf.cfg.rhel.7.7.gcc.7.4.0.cuda.10.1" \
    -DCMAKE_CXX_COMPILER_ARG1="-F/projects/opt/ppc64le/ibm/xlc-16.1.1.6/xlC/16.1.1/etc/xlc.cfg.rhel.7.7.gcc.7.4.0.cuda.10.1"
cmake --build $CI_FLCL_BUILD_DIR --parallel
cmake --install $CI_FLCL_BUILD_DIR
ctest
# printenv | grep LD_LIBRARY_PATH
#rm -rf $CI_FLCL_BUILD_DIR