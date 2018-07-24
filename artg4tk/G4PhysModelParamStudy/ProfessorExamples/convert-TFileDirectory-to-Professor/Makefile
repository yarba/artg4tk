CXX = g++ -g
CXXFLAGS = `$(ROOTSYS)/bin/root-config --cflags --glibs`
LDLIBS = `$(ROOTSYS)/bin/root-config --libs`

# --> NOT in Root6 LDLIBS += -lCintex -lReflex
LDLIBS += $(MRB_BUILDDIR)/artg4tk/lib/libartg4tk_G4PhysModelParamStudy_AnalysisProducts_dict.so
LDLIBS += $(MRB_BUILDDIR)/artg4tk/lib/libartg4tk_G4PhysModelParamStudy_AnalysisProducts.so

BINARIES = Convert2Professor
TARGETS = Convert2Professor.o   

#--- if using 'make all' ---#
all : $(TARGETS)

#--- if making individual targets ---#

Convert2Professor.o : Convert2Professor.cc
	$(CXX) $(CXXFLAGS) -I$(MRB_SOURCE)/artg4tk -o $*.o -c $*.cc #compile
	$(CXX) -o $* $*.o $(LDLIBS) $(CXXFLAGS)       #link

clean:
	rm -f $(BINARIES) $(TARGETS)
