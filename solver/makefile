CC=gcc
LK=gcc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: solver.exe

solver.exe: solver.c solver.o DGauss.c DGauss.o makefile
	$(LK) $(LK_FLAGS) solver.o DGauss.o -o solver.exe
	cp solver.exe ~/bin
    
.c.obj: 
	$(CC) $(CC_FLAGS) $<
