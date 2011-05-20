CC=gcc
LK=gcc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: solver.exe

solver.exe: solver.c solver.o DGauss.c DGauss.o
	$(LK) $(LK_FLAGS) solver.o DGauss.o -o solver_p.exe
	cp solver_p.exe ~/bin
    
.c.obj: 
	$(CC) $(CC_FLAGS) $<
