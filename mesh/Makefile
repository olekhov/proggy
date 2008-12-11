CC=mpicc
LK=mpicc
CC_FLAGS=-c
LK_FLAGS=-O3 -lm

all: mesh.exe testmesh.exe

mesh.exe: mesh.o vars.o misc.o renum.o matching.o
	$(LK) $(LK_FLAGS) mesh.o vars.o misc.o renum.o matching.o -o mesh.exe

testmesh.exe: testmesh.o
	$(LK) $(LK_FLAGS) testmesh.o -o testmesh.exe
    

clear:
	rm mesh.exe *.o 

.c.obj: 
	$(CC) $(CC_FLAGS) $<
