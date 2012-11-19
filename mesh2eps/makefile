CC=gcc
LK=gcc
CC_FLAGS=-c
LK_FLAGS=

all: mesh2eps.exe dmesh2eps.exe gmesh2eps.exe

gmesh2eps.exe: gmesh2eps.o
	$(LK) $(LK_FLAGS) gmesh2eps.o -o gmesh2eps.exe

mesh2eps.exe: mesh2eps.o
	$(LK) $(LK_FLAGS) mesh2eps.o -o mesh2eps.exe

dmesh2eps.exe: dmesh2eps.o
	$(LK) $(LK_FLAGS) dmesh2eps.o -o dmesh2eps.exe

e_mesh2eps.exe: e_mesh2eps.o
	$(LK) $(LK_FLAGS) e_mesh2eps.o -o e_mesh2eps.exe

.c.obj:
	$(CC) $(CC_FLAGS) $<
