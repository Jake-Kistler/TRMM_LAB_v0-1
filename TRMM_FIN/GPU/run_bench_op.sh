#!/usr/bin/env bash

MIN=${1:-32}
MAX=${2:-512}
STEP=${3:-32}
OBJ=./Obj-A

echo "Running benchmarks locally (WSL MPICH)"

for X in $OBJ/*.run_bench.x; do
    echo "Bench: $X"
    mpiexec -n 1 "$X" "$MIN" "$MAX" "$STEP" 1 -3 "${X}.timing.csv"
done
