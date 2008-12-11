CC=cl
LK=cl
CC_FLAGS=-c
LK_FLAGS=

all: solver0.exe

solver0.exe: solver.c solver.obj DGauss.c DGauss.obj
    $(LK) $(LK_FLAGS) solver.obj DGauss.obj -o solver0.exe
    #solver sq16b.d
    
.c.obj: 
    $(CC) $(CC_FLAGS) $<
