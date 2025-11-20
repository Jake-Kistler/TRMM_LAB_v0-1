#!/usr/bin/env bash

MIN=${1:-32}
MAX=${2:-256}
STEP=${3:-32}
OBJ=./Obj-A

echo "Running verifier locally (WSL MPICH)"

for X in $OBJ/*.run_verifier.x; do
    echo "Verifier: $X"
    mpiexec -n 1 $X $MIN $MAX $STEP 1 -3 "$X.verifier.csv"
done
