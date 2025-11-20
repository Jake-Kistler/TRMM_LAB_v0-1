#!/usr/bin/env bash
# Build TEST binaries locally under WSL + MPICH

set -e

echo "Building test binaries (WSL Local Mode)"

OBJ=./Obj-A

mpicc -std=c99 -O2 -mavx2 -mfma -c verify_op.c -o verify_op.c.o
mpicc -std=c99 -O2 -mavx2 -mfma -c baseline_op.c -o baseline_op.c.o

for SRC in $OBJ/*.c; do
    CU="${SRC}.cu"
    echo "Compiling CPU + CUDA for $SRC"

    mpicc -c -DCOMPUTE_NAME=test \
            $SRC -o "${SRC}.o"

    nvcc -c $CU -o "${CU}.o"

    nvcc -ccbin=mpicc -lstdc++ -lcudart -lm \
         verify_op.c.o baseline_op.c.o \
         "${CU}.o" "${SRC}.o" \
         -o "${SRC}.run_verifier.x"
done

echo "Done building test binaries."
