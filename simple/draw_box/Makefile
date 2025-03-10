CXXFLAGS = -g -std=c++17 -fPIC
NVCCFLAGS = -arch=sm_86
TARGET = a.out
CXX = g++
NVCC = nvcc

AR = ar
RANLIB = ranlib

CPPSRCS:=$(shell find ./ -type f -name '*.cpp')
CPPOBJS = $(CPPSRCS:%.cpp=%.o)

CUSRCS:=$(shell find ./ -type f -name '*.cu')
CUOBJS = $(CUSRCS:%.cu=%.o)

INCS:= $(wildcard *.h)

CFLAGS+= -Wall -std=c++17 -g \
		 -I /opt/homebrew/Cellar/opencv/4.8.1_1/include/opencv4 \
		 -I /opt/homebrew/Cellar/opencv/4.8.1_1/include/opencv4 \
		 -L/usr/local/cuda/lib64 -lcudart -lcufft

NVCCFLAGS+= --ptxas-options=-v --use_fast_math -lcufft

PKGS:= opencv4 tbb

pkg_flags = $(shell pkg-config --cflags --libs $1)

$(foreach pkg,$(PKGS),\
    $(eval CFLAGS += $(shell pkg-config --cflags $(pkg))) \
    $(eval LIBS += $(shell pkg-config --libs $(pkg))) \
)


%.o: %.cpp $(INCS) Makefile
	@echo $(CFLAGS)
	$(CXX) -c -o $@ $(CFLAGS) $<

%.o: %.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@	

a.out : $(CPPOBJS) $(CUOBJS)
	$(CXX) -o $@ $(CPPOBJS) $(CUOBJS) $(LIBS) $(CFLAGS)

clean:
	rm -f $(CPPOBJS) $(CUOBJS) $(TARGET)


.PHONY: clean
