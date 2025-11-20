#!/usr/bin/env bash
# Build BENCH binaries locally under WSL + MPICH

set -e

echo "Building bench binaries (WSL Local Mode)"

OBJ=./Obj-A

mpicc -std=c99 -O2 -mavx2 -mfma -c timer_op.c -o timer_op.c.o

for SRC in $OBJ/*.c; do
    CU="${SRC}.cu"

    echo "Compiling CPU + CUDA for $SRC (benchmark)"

    mpicc -c -DCOMPUTE_NAME=test \
        $SRC -o "${SRC}.o"

    nvcc -c $CU -o "${CU}.o"

    nvcc -ccbin=mpicc -lstdc++ -lcudart -lm \
        timer_op.c.o \
        "${CU}.o" "${SRC}.o" \
        -o "${SRC}.run_bench.x"
done

echo "Done building bench binaries."
