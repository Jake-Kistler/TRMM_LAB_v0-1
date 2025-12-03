# Makefile for Objective B, Task T01: Split + Interchange loop variants
# Location: TRMM_FIN/CPU/Obj-B/T01/

CC = mpicc
CFLAGS = -O3 -g -Wall -I../../
LDFLAGS = -lm

TIMER_SRC = ../../timer_op.c
VERIFY_SRC = ../../verify_op.c
BASELINE_SRC = ../../baseline_op.c

PERMS = ijp jip ipj pij jpi pji

BENCH_BINS = $(PERMS:%=bench_%)
VERIFY_BINS = $(PERMS:%=verify_%)
SRCS = $(PERMS:%=obj_b_t01_%.c)

all: generate build verify

# Generate C sources using the shared script in T00
GEN_SCRIPT = ../T00/generate_split_loops.py

generate: $(SRCS)

$(SRCS): $(GEN_SCRIPT)
	python3 $(GEN_SCRIPT)

baseline_op.o: $(BASELINE_SRC)
	$(CC) $(CFLAGS) -c $(BASELINE_SRC) -o baseline_op.o

BENCH_FLAGS = \
	-DCOMPUTE_NAME_TST=tuned_t01_$* \
	-DDISTRIBUTED_ALLOCATE_NAME_TST=baseline_allocate \
	-DDISTRIBUTE_DATA_NAME_TST=baseline_distribute \
	-DCOLLECT_DATA_NAME_TST=baseline_collect \
	-DDISTRIBUTED_FREE_NAME_TST=baseline_free \
	-DCOMPUTE_NAME=tuned_t01_$*

bench_%: obj_b_t01_%.c $(TIMER_SRC) baseline_op.o
	$(CC) $(CFLAGS) $(BENCH_FLAGS) -o $@ $(TIMER_SRC) $< baseline_op.o $(LDFLAGS)

VERIFY_FLAGS = \
	-DCOMPUTE_NAME_TST=tuned_t01_$* \
	-DCOMPUTE_NAME_REF=baseline \
	-DDISTRIBUTED_ALLOCATE_NAME_TST=baseline_allocate \
	-DDISTRIBUTED_ALLOCATE_NAME_REF=baseline_allocate \
	-DDISTRIBUTE_DATA_NAME_TST=baseline_distribute \
	-DDISTRIBUTE_DATA_NAME_REF=baseline_distribute \
	-DCOLLECT_DATA_NAME_TST=baseline_collect \
	-DCOLLECT_DATA_NAME_REF=baseline_collect \
	-DDISTRIBUTED_FREE_NAME_TST=baseline_free \
	-DDISTRIBUTED_FREE_NAME_REF=baseline_free \
	-DCOMPUTE_NAME=tuned_t01_$*

verify_%: obj_b_t01_%.c $(VERIFY_SRC) baseline_op.o
	$(CC) $(CFLAGS) $(VERIFY_FLAGS) -o $@ $(VERIFY_SRC) $< baseline_op.o $(LDFLAGS)

build: $(BENCH_BINS) $(VERIFY_BINS)

verify: $(VERIFY_BINS)
	@echo "--- Running Verification ---"
	@for p in $(PERMS); do \
		echo "Verifying $$p..."; \
		mpirun -n 1 ./verify_$$p 100 101 1 100 100 || exit 1; \
	done
	@echo "All verifications passed!"

results.csv: $(BENCH_BINS)
	@echo "--- Running Benchmarks ---"
	@echo "perm,size,gflops" > results.csv
	@for p in $(PERMS); do \
		echo "Benchmarking $$p..."; \
		for s in $$(seq 32 32 1024); do \
			output=$$(mpirun -n 1 ./bench_$$p $$s $$(($$s + 1)) 1 $$s $$s | tail -n 1); \
			echo "$$p,$$s,$$output" >> results.csv; \
		done \
	done
	@echo "Benchmarks complete. Data saved to results.csv"

run_bench: results.csv

clean:
	rm -f bench_* verify_* obj_b_t01_*.c baseline_op.o results.csv

.PHONY: all generate build verify run_bench clean