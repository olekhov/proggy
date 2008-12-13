CC=mpicc
LK=mpicc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: sigma_tau.exe

sigma_tau.exe: sigma_tau.c sigma_tau.o
	$(LK) $(LK_FLAGS) sigma_tau.o -o sigma_tau.exe
	cp sigma_tau.exe ~/bin
    
.c.obj: 
	$(CC) $(CC_FLAGS) $<
