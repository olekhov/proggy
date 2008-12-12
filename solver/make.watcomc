CC=cl
LK=cl
CC_FLAGS=-c
LK_FLAGS=

all: solver.exe

solver.exe: solver.c solver.obj DGauss.c DGauss.obj
    $(LK) $(LK_FLAGS) solver.obj DGauss.obj
    #solver sq16b.d
    
.c.obj: 
    $(CC) $(CC_FLAGS) $<
