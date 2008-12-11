CC=cl
LK=cl
CC_FLAGS=-c
LK_FLAGS=

all: solver_p.exe

solver_p.exe: solver.c solver.obj DGauss.c DGauss.obj
    $(LK) $(LK_FLAGS) solver.obj DGauss.obj -o solver_p.exe
    #solver sq16b.d
    
.c.obj: 
    $(CC) $(CC_FLAGS) $<
