CC=mpicc
LK=mpicc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: genpsi.exe

genpsi.exe: genpsi.c genpsi.o
	$(LK) $(LK_FLAGS) genpsi.o -o genpsi.exe
	cp genpsi.exe ~/bin
    
.c.obj: 
	$(CC) $(CC_FLAGS) $<
