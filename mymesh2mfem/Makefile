
CXX=g++
LD=g++
CXXFLAGS=-c




meshcvr: meshcvr.o mymesh.o edge.o element.o nodes.o
	$(LD) $(LDFLAGS) $^ -o $@

%.o: %.cxx 
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm *.o meshcvr
