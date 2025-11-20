###############################################
# Makefile for LOCAL WSL + OpenMPI + CUDA build
###############################################

MPICC       = mpicc
NVCC        = nvcc

CFLAGS_HOST = -std=c99 -O2 -mavx2 -mfma
LDFLAGS     = -lstdc++ -lcudart -lm -Xcompiler=-fopenmp

BASELINE    = baseline_op.c
VERIFY_OP   = verify_op.c
TIMER_OP    = timer_op.c

OBJDIR      = Obj-A

# Variant base names (NO extensions)
VAR01       = tuned_variant01_op
VAR02       = tuned_variant02_op
VAR03       = tuned_variant03_op

###############################################
# Top-level target
###############################################

all-local: clean-local \
	$(OBJDIR)/$(VAR01).run_verifier.x \
	$(OBJDIR)/$(VAR02).run_verifier.x \
	$(OBJDIR)/$(VAR03).run_verifier.x \
	$(OBJDIR)/$(VAR01).run_bench.x \
	$(OBJDIR)/$(VAR02).run_bench.x \
	$(OBJDIR)/$(VAR03).run_bench.x

clean-local:
	rm -f *.o *.x
	rm -f $(OBJDIR)/*.o $(OBJDIR)/*.x

###############################################
# Build baseline (REF implementation)
#   defines: baseline, baseline_allocate, ...
###############################################

baseline_op.o: $(BASELINE)
	$(MPICC) $(CFLAGS_HOST) \
	    -DCOMPUTE_NAME=baseline \
	    -DDISTRIBUTED_ALLOCATE_NAME=baseline_allocate \
	    -DDISTRIBUTED_FREE_NAME=baseline_free \
	    -DDISTRIBUTE_DATA_NAME=baseline_distribute \
	    -DCOLLECT_DATA_NAME=baseline_collect \
	    -c $(BASELINE) -o $@

###############################################
# Build verifier harness
#   maps *_REF -> baseline_*
#        *_TST -> test_*
###############################################

verify_op.o: $(VERIFY_OP)
	$(MPICC) $(CFLAGS_HOST) \
	    -DCOMPUTE_NAME_REF=baseline \
	    -DDISTRIBUTED_ALLOCATE_NAME_REF=baseline_allocate \
	    -DDISTRIBUTED_FREE_NAME_REF=baseline_free \
	    -DDISTRIBUTE_DATA_NAME_REF=baseline_distribute \
	    -DCOLLECT_DATA_NAME_REF=baseline_collect \
	    -DCOMPUTE_NAME_TST=test \
	    -DDISTRIBUTED_ALLOCATE_NAME_TST=test_allocate \
	    -DDISTRIBUTED_FREE_NAME_TST=test_free \
	    -DDISTRIBUTE_DATA_NAME_TST=test_distribute \
	    -DCOLLECT_DATA_NAME_TST=test_collect \
	    -c $(VERIFY_OP) -o $@

###############################################
# Build timer harness (bench)
#   same REF/TST mapping as verify_op
###############################################

timer_op.o: $(TIMER_OP)
	$(MPICC) $(CFLAGS_HOST) \
	    -DCOMPUTE_NAME_REF=baseline \
	    -DDISTRIBUTED_ALLOCATE_NAME_REF=baseline_allocate \
	    -DDISTRIBUTED_FREE_NAME_REF=baseline_free \
	    -DDISTRIBUTE_DATA_NAME_REF=baseline_distribute \
	    -DCOLLECT_DATA_NAME_REF=baseline_collect \
	    -DCOMPUTE_NAME_TST=test \
	    -DDISTRIBUTED_ALLOCATE_NAME_TST=test_allocate \
	    -DDISTRIBUTED_FREE_NAME_TST=test_free \
	    -DDISTRIBUTE_DATA_NAME_TST=test_distribute \
	    -DCOLLECT_DATA_NAME_TST=test_collect \
	    -c $(TIMER_OP) -o $@

###############################################
# Variant CPU files — define TEST dispatcher
#   Obj-A/foo.o  <-  Obj-A/foo.c
###############################################

$(OBJDIR)/%.o: $(OBJDIR)/%.c
	$(MPICC) $(CFLAGS_HOST) \
	    -DCOMPUTE_NAME=test \
	    -DDISTRIBUTE_DATA_NAME=test_distribute \
	    -DCOLLECT_DATA_NAME=test_collect \
	    -DDISTRIBUTED_ALLOCATE_NAME=test_allocate \
	    -DDISTRIBUTED_FREE_NAME=test_free \
	    -c $< -o $@

###############################################
# Variant CUDA files — same TEST dispatcher
#   Obj-A/foo.cu.o  <-  Obj-A/foo.cu
###############################################

$(OBJDIR)/%.cu.o: $(OBJDIR)/%.cu
	$(NVCC) \
	    -DCOMPUTE_NAME=test \
	    -DDISTRIBUTE_DATA_NAME=test_distribute \
	    -DCOLLECT_DATA_NAME=test_collect \
	    -DDISTRIBUTED_ALLOCATE_NAME=test_allocate \
	    -DDISTRIBUTED_FREE_NAME=test_free \
	    -c $< -o $@

###############################################
# Build verifier executables (REF + TST)
#   Obj-A/foo.run_verifier.x
###############################################

$(OBJDIR)/%.run_verifier.x: verify_op.o baseline_op.o $(OBJDIR)/%.o $(OBJDIR)/%.cu.o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) $^ -o $@

###############################################
# Build bench executables (TST only)
#   Obj-A/foo.run_bench.x
###############################################

$(OBJDIR)/%.run_bench.x: timer_op.o $(OBJDIR)/%.o $(OBJDIR)/%.cu.o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) $^ -o $@

###############################################
# END
###############################################
