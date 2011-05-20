CC=gcc
LK=gcc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: mesh.exe testmesh.exe

mesh.exe: mesh.o vars.o misc.o renum.o matching.o Makefile
	$(LK) $(LK_FLAGS) mesh.o vars.o misc.o renum.o matching.o -o mesh.exe
	cp mesh.exe ~/bin

testmesh.exe: testmesh.o
	$(LK) $(LK_FLAGS) testmesh.o -o testmesh.exe
    

clear:
	rm *.exe *.o 

.c.obj: 
	$(CC) $(CC_FLAGS) $<
