###############################################
# Makefile for LOCAL WSL + MPICH + CUDA build
###############################################

# ---- Compiler Setup ----
MPICC       = mpicc
NVCC        = nvcc

CFLAGS_HOST = -std=c99 -O2 -mavx2 -mfma
LDFLAGS     = -lstdc++ -lcudart -lm -Xcompiler=-fopenmp

# Base files
BASELINE      = baseline_op.c
VERIFY_OP     = verify_op.c
TIMER_OP      = timer_op.c

# Variants
VAR01_C     = tuned_variant01_op.c
VAR01_CU    = tuned_variant01_op.c.cu

VAR02_C     = tuned_variant02_op.c
VAR02_CU    = tuned_variant02_op.c.cu

VAR03_C     = tuned_variant03_op.c
VAR03_CU    = tuned_variant03_op.c.cu


OBJDIR = Obj-A

all-local: clean-local \
           $(OBJDIR)/$(VAR01_C).run_verifier.x \
           $(OBJDIR)/$(VAR02_C).run_verifier.x \
           $(OBJDIR)/$(VAR03_C).run_verifier.x \
           $(OBJDIR)/$(VAR01_C).run_bench.x \
           $(OBJDIR)/$(VAR02_C).run_bench.x \
           $(OBJDIR)/$(VAR03_C).run_bench.x

clean-local:
	rm -f *.o *.x
	rm -f $(OBJDIR)/*.o $(OBJDIR)/*.x

###############################################
# Compile verifier executables
###############################################

$(OBJDIR)/$(VAR01_C).run_verifier.x: $(VERIFY_OP) $(BASELINE) $(OBJDIR)/$(VAR01_C).o $(OBJDIR)/$(VAR01_CU).o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) \
		$^ -o $@

$(OBJDIR)/$(VAR02_C).run_verifier.x: $(VERIFY_OP) $(BASELINE) $(OBJDIR)/$(VAR02_C).o $(OBJDIR)/$(VAR02_CU).o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) \
		$^ -o $@

$(OBJDIR)/$(VAR03_C).run_verifier.x: $(VERIFY_OP) $(BASELINE) $(OBJDIR)/$(VAR03_C).o $(OBJDIR)/$(VAR03_CU).o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) \
		$^ -o $@

###############################################
# Compile bench executables
###############################################

$(OBJDIR)/$(VAR01_C).run_bench.x: $(TIMER_OP) $(OBJDIR)/$(VAR01_C).o $(OBJDIR)/$(VAR01_CU).o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) \
		$^ -o $@

$(OBJDIR)/$(VAR02_C).run_bench.x: $(TIMER_OP) $(OBJDIR)/$(VAR02_C).o $(OBJDIR)/$(VAR02_CU).o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) \
		$^ -o $@

$(OBJDIR)/$(VAR03_C).run_bench.x: $(TIMER_OP) $(OBJDIR)/$(VAR03_C).o $(OBJDIR)/$(VAR03_CU).o
	$(NVCC) -ccbin=$(MPICC) $(LDFLAGS) \
		$^ -o $@

###############################################
# Compile CUDA + CPU variants
###############################################

$(OBJDIR)/%.c.o: $(OBJDIR)/%.c
	$(MPICC) $(CFLAGS_HOST) -c $< -o $@

$(OBJDIR)/%.cu.o: $(OBJDIR)/%.cu
	$(NVCC) -c $< -o $@

###############################################
# END
###############################################
