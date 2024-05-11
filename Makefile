# var
MODULE  = $(notdir $(CURDIR))
PEPS    = E26,E302,E305,E401,E402,E701,E702

# version
D_VER      = 2.108.0
DEBIAN_VER = 12

# dir
CWD   = $(CURDIR)
INC   = $(CWD)/inc
SRC   = $(CWD)/src
TMP   = $(CWD)/tmp
DISTR = $(HOME)/distr

# tool
CURL   = curl -L -o
CF     = clang-format -style=file
PY     = bin/python3
PIP    = bin/pip3
PEP    = autopep8
DC     = /usr/bin/dmd
DUB    = /usr/bin/dub
RUN    = $(DUB) run   --compiler=$(DC)
BLD    = $(DUB) build --compiler=$(DC)

# src
C  += $(wildcard src/*.cpp)
H  += $(wildcard inc/*.hpp)
CP += tmp/$(MODULE).lexer.cpp tmp/$(MODULE).parser.cpp
HP += tmp/$(MODULE).lexer.hpp tmp/$(MODULE).parser.hpp

Y += $(wildcard lib/*.py)
D += $(wildcard src/*.d*)
G ?= pcb/1x2in/grb/1x2in.nc

# cfg
CFLAGS += -I$(INC) -I$(SRC) -I$(TMP)

# all
.PHONY: all
all: bin/$(MODULE) $(G)
	$^

.PHONY: lab
lab:
	bin/jupyter $@

# format
.PHONY: format
format: tmp/format_py tmp/format_c tmp/format_d
tmp/format_py: $(Y)
	$(PEP) --ignore $(PEPS) -i $? && touch $@
tmp/format_c: $(C) $(H)
	$(CF) -i $? && touch $@
tmp/format_d: $(D)
	$(RUN) dfmt -- -i $? && touch $@

# rule
# bin/$(MODULE): $(D) dub.json Makefile
# 	$(BLD) && touch $@

bin/$(MODULE): $(C) $(CP) $(H) $(HP) Makefile
	$(CXX) $(CFLAGS) -o $@ $(C) $(CP) $(L)

tmp/$(MODULE).lexer.cpp tmp/$(MODULE).lexer.hpp: src/$(MODULE).lex
	flex -o $@ $<
tmp/$(MODULE).parser.cpp tmp/$(MODULE).parser.hpp: src/$(MODULE).yacc
	bison -o $@ $<

# doc
.PHONY: doc
doc:

.PHONY: install update gz ref
install: doc gz ref
	$(MAKE) update
update: $(PIP)
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(PIP) install -U -r requirements.txt
gz:  $(DC) $(DUB)
ref:

$(DC) $(DUB): $(HOME)/distr/SDK/dmd_$(D_VER)_amd64.deb
	sudo dpkg -i $< && sudo touch $(DC) $(DUB)
$(HOME)/distr/SDK/dmd_$(D_VER)_amd64.deb:
	$(CURL) $@ https://downloads.dlang.org/releases/2.x/$(D_VER)/dmd_$(D_VER)-0_amd64.deb

$(PY) $(PIP):
	python3 -m venv .
