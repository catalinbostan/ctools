## ======================================================================
## Makefile
## SolarStuff project
## Author: Bernard TATIN <bernard dot tatin at outlook dot org>
##
## Created on 3 mars 2016, 22:20
##
## ======================================================================

##    The MIT License (MIT)
##
##    Copyright (c) 2016 Bernard TATIN <bernard dot tatin at outlook dot org>
##
##    Permission is hereby granted, free of charge, to any person obtaining a copy
##    of this software and associated documentation files (the "Software"), to deal
##    in the Software without restriction, including without limitation the rights
##    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##    copies of the Software, and to permit persons to whom the Software is
##    furnished to do so, subject to the following conditions:
##
##    The above copyright notice and this permission notice shall be included in all
##    copies or substantial portions of the Software.
##
##    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##    SOFTWARE.

os = $(shell uname)

ifeq ($(os), SunOS)
	CC ?= cc
	LIBS = -L/usr/openwin/lib -lrt
	arch ?= -m64
	optim ?= -xO3
	CFLAGS += -errtags=yes -std=c11
	ipath = -I./solaris
else ifeq ($(os), FreeBSD)
	CC ?= gcc6
	LIBS = -L/usr/local/lib
	arch ?= -m64
	optim ?= -O3
	CFLAGS += -Wall -pedantic -std=c11
	ipath = -I/usr/local/include -I./freebsd
endif

LD = $(CC)
LIBS += -lX11 -lpthread
RM = rm -f

ipath += -I./include
CFLAGS += $(arch) $(optim) $(ipath) -D_REENTRANT
LDFLAGS += $(arch)

odir = objs$(arch)
src = src

MAIN = solar-stuff
EXE = $(MAIN)$(arch)
SRC = $(src)/$(MAIN).c $(src)/Xhelper.c $(src)/Xconf.c $(src)/solar-infos.c $(src)/clist.c

objs = $(SRC:.c=.o)
OBJS=$(objs:$(src)/%=$(odir)/%)

all: $(odir) $(EXE)

$(odir):
	mkdir -p $@

$(EXE): $(OBJS)
	$(LD) -o $(EXE) $(OBJS) $(LDFLAGS) $(LIBS)

$(odir)/%.o: $(src)/%.c
	$(CC) -c $< -o $@ $(CFLAGS)

test: $(EXE)
	./$(EXE)

clean:
	echo "objs: $(objs)"
	echo "OBJS: $(OBJS)"
	$(RM) $(EXE) $(OBJS)
	$(RM) a.out core

.PHONY: all test clean

