CC=cl
LK=cl
CC_FLAGS=-c
LK_FLAGS=

all: genpsi.exe

genpsi.exe:  genpsi.obj 
    $(LK) $(LK_FLAGS) genpsi.obj
    #solver sq16b.d
    
.c.obj: 
    $(CC) $(CC_FLAGS) $<

