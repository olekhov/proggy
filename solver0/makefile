CC=gcc
LK=gcc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: psi0.exe

psi0.exe: solver.c solver.o DGauss.c DGauss.o
	$(LK) $(LK_FLAGS) solver.o DGauss.o -o psi0.exe
	cp psi0.exe ~/.bin
    
.c.obj: 
	$(CC) $(CC_FLAGS) $<
