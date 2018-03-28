#
# Copyright (C) 2015 by Chris Simmonds <chris@2net.co.uk>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

# LOCAL_CFLAGS := -Wall -Wextra -Wformat=2 -Werror
LOCAL_CFLAGS := -Wall

.PHONY : clean uninstall

prefix ?= /usr
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin

PROGRAM_SRC = procrank.cpp
PROGRAM_BIN = procrank
PROGRAM_TGT = $(DESTDIR)$(bindir)/$(PROGRAM_bin)

CXXFLAGS = -std=c++14

all : $(PROGRAM_BIN)

$(PROGRAM_BIN) : $(PROGRAM_SRC) libpagemap/libpagemap.a
	$(CXX) $(CXXFLAGS) $(LOCAL_CFLAGS) $(PROGRAM_SRC) -Ilibpagemap/include -Llibpagemap -lpagemap -o procrank

$(PROGRAM_TGT) : $(PROGRAM_BIN)
	install -d $(DESTDIR)$(bindir)
	install -m 0755 $^ $@

libpagemap/libpagemap.a:
	make -C libpagemap

clean :
	rm -f $(PROGRAM_BIN)
	make -C libpagemap clean

install : $(PROGRAM_TGT)

uninstall :
	rm -f $(PROGRAM_TGT)
