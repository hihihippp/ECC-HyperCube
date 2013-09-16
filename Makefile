# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.
CXX = g++
BOOST_DIR = .
INCLUDES_DIR = ./includes
SRC_DIR = ./src

# Where to find user code.
USER_DIR = .

# Flags passed to the preprocessor.
CPPFLAGS += -I$(BOOST_DIR)

# Flags passed to the C++ compiler.
CXXFLAGS += -Wall -Wextra -fms-extensions -O3 -std=c++0x 

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    CXX=c++
    CXXFLAGS += -stdlib=libc++ 
endif

# created to the list.
ALL = cubecode

all : $(ALL)

clean :
	rm -f $(ALL) *.o

hypercube.o: $(SRC_DIR)/hypercube.cc $(INCLUDES_DIR)/hypercube.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(SRC_DIR)/hypercube.cc

unitcube.o: $(SRC_DIR)/unitcube.cc $(INCLUDES_DIR)/unitcube.h $(INCLUDES_DIR)/hypercube.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(SRC_DIR)/unitcube.cc

cubecode.o: $(SRC_DIR)/cubecode.cc $(INCLUDES_DIR)/cubecode.h $(INCLUDES_DIR)/hypercube.h \
				    $(INCLUDES_DIR)/hypercube.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(SRC_DIR)/cubecode.cc

reedmuller.o: $(SRC_DIR)/reedmuller.cc $(INCLUDES_DIR)/reedmuller.h
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(SRC_DIR)/reedmuller.cc

main.o : $(USER_DIR)/main.cc 	$(INCLUDES_DIR)/reedmuller.h\
														 	$(INCLUDES_DIR)/unitcube.h  \
                     					$(INCLUDES_DIR)/cubecode.h \
															$(INCLUDES_DIR)/hypercube.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/main.cc

cubecode: main.o reedmuller.o cubecode.o hypercube.o unitcube.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $^ -o $@ 

