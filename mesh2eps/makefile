CC=cl
LK=cl
CC_FLAGS=/c
LK_FLAGS=

all: mesh2eps.exe dmesh2eps.exe

mesh2eps.exe: mesh2eps.obj
    $(LK) $(LK_FLAGS) mesh2eps.obj

dmesh2eps.exe: dmesh2eps.obj
    $(LK) $(LK_FLAGS) dmesh2eps.obj

e_mesh2eps.exe: e_mesh2eps.obj
    $(LK) $(LK_FLAGS) e_mesh2eps.obj

.c.obj:
    $(CC) $(CC_FLAGS) $<