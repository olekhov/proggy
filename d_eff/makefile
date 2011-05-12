CC=gcc
LK=gcc
CC_FLAGS=-c -O3
LK_FLAGS=-lm

all: d_eff.exe

d_eff.exe: d_eff.c d_eff.o
	$(LK) $(LK_FLAGS) d_eff.o -o d_eff.exe
	cp d_eff.exe ~/.bin
    
.c.obj: 
	$(CC) $(CC_FLAGS) $<
