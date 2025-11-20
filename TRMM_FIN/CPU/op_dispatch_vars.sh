#!/usr/bin/env bash

######################################
# STUDENT_TODO                       #
# DO NOT CHANGE THIS FOLLOWING LINE: #
# UNTIL YOU HAVE A CORRECT AND FASTER#
# BASELINE.                          #
OP_BASELINE_FILE="baseline_op.c"     #
######################################

######################################################
# You can even change the compiler flags if you want #
######################################################
CC=mpicc
# CFLAGS="-std=c99 -g -O0 -fopenmp" # for debugging
CFLAGS="-std=c99 -O2 -mavx2 -mfma -fopenmp"

