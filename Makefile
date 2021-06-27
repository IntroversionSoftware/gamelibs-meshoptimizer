# -*- Makefile -*- for meshoptimizer

.SECONDEXPANSION:
.SUFFIXES:

ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
        QUIET          = @
        QUIET_CXX      = @echo '   ' CXX $<;
        QUIET_AR       = @echo '   ' AR $@;
        QUIET_RANLIB   = @echo '   ' RANLIB $@;
        QUIET_INSTALL  = @echo '   ' INSTALL $<;
        export V
endif
endif

LIB      = libmeshoptimizer.a
AR      ?= ar
ARFLAGS ?= rc
CXX     ?= g++
RANLIB  ?= ranlib
RM      ?= rm -f

BUILD_DIR := build
BUILD_ID  ?= default-build-id
OBJ_DIR   := $(BUILD_DIR)/$(BUILD_ID)

ifeq (,$(BUILD_ID))
$(error BUILD_ID cannot be an empty string)
endif

prefix ?= /usr/local
libdir := $(prefix)/lib
includedir := $(prefix)/include

CXXFLAGS ?= -O2
CXXFLAGS += -I$(includedir)

HEADERS = \
	src/meshoptimizer.h \

SOURCES = \
	src/*.cpp \

SOURCES := $(wildcard $(SOURCES))

HEADERS_INST := $(patsubst src/%,$(includedir)/%,$(HEADERS))
OBJECTS := $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(SOURCES))

.PHONY: install

all: $(OBJ_DIR)/$(LIB)

$(includedir)/%.h: src/%.h
	-@if [ ! -d $(includedir)  ]; then mkdir -p $(includedir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

$(libdir)/%.a: $(OBJ_DIR)/%.a
	-@if [ ! -d $(libdir)  ]; then mkdir -p $(libdir); fi
	$(QUIET_INSTALL)cp $< $@
	@chmod 0644 $@

install: $(HEADERS_INST) $(libdir)/$(LIB)

clean:
	$(RM) -r $(OBJ_DIR)

distclean: clean
	$(RM) -r $(BUILD_DIR)

$(OBJ_DIR)/$(LIB): $(OBJECTS)
	$(QUIET_AR)$(AR) $(ARFLAGS) $@ $^
	$(QUIET_RANLIB)$(RANLIB) $@

$(OBJ_DIR)/%.o: %.cpp $(OBJ_DIR)/.cflags | $$(@D)/.
	$(QUIET_CXX)$(CXX) $(CXXFLAGS) -o $@ -c $<

.PRECIOUS: $(OBJ_DIR)/. $(OBJ_DIR)%/.

$(OBJ_DIR)/.:
	$(QUIET)mkdir -p $@

$(OBJ_DIR)%/.:
	$(QUIET)mkdir -p $@

TRACK_CFLAGS = $(subst ','\'',$(CXX) $(CXXFLAGS))

$(OBJ_DIR)/.cflags: .force-cflags | $$(@D)/.
	@FLAGS='$(TRACK_CFLAGS)'; \
    if test x"$$FLAGS" != x"`cat $(OBJ_DIR)/.cflags 2>/dev/null`" ; then \
        echo "    * rebuilding meshoptimizer: new build flags or prefix"; \
        echo "$$FLAGS" > $(OBJ_DIR)/.cflags; \
    fi

.PHONY: .force-cflags
