TARGETS = msconnect msclose mslisten msaccept mssend msrecv \
	msrecvraw mssendraw

MATDIR = /usr/local/matlabr2008a

ARCH = $(shell uname -m)

ifeq ($(ARCH),x86_64)
SUFFIX = mexa64
endif

ifeq ($(ARCH),i686)
SUFFIX = mexglx
endif

ifeq ($(ARCH),i586)
SUFFIX = mexglx
endif

ifeq ($(ARCH),i386)
SUFFIX = mexglx
endif

CXX = g++-4.2
CC = gcc-4.2
CFLAGS = -O3 -DMATLAB_MEX_FILE -fPIC -fomit-frame-pointer -Wall 

INCDIR = -I$(MATDIR)/extern/include -I. -I/usr/include

all : $(patsubst %,../%.$(SUFFIX),$(TARGETS))

../msrecv.$(SUFFIX) : msrecv.o matvar.o
	$(CXX) $(CFLAGS) -shared $^ -o $@

../mssend.$(SUFFIX) : mssend.o matvar.o
	$(CXX) $(CFLAGS) -shared $^ -o $@

../%.$(SUFFIX) : %.o
	$(CC) $(CFLAGS) -shared $^ -o $@

%.o : %.cpp
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $@

%.o : %.c
	$(CC) $(CFLAGS) $(INCDIR) -c $< -o $@

clean : 
	rm -rf $(patsubst %,../%.$(SUFFIX),$(TARGETS)) *.o
