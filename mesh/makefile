CC=cl
LK=cl
CC_FLAGS=-c
LK_FLAGS=/Op

all: mesh.exe testmesh.exe

mesh.exe: mesh.obj vars.obj misc.obj renum.obj matching.obj
    $(LK) $(LK_FLAGS) mesh.obj vars.obj misc.obj renum.obj matching.obj

testmesh.exe: testmesh.obj
    $(LK) $(LK_FLAGS) testmesh.obj
    

clear:
    del mesh.exe
    del mesh.obj

.c.obj: 
    $(CC) $(CC_FLAGS) $<
