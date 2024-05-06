# var
MODULE  = $(notdir $(CURDIR))

# version
D_VER = 2.108.0
NET_VER    = 8.0.200
DEBIAN_VER = 12

# dir
CWD   = $(CURDIR)
DISTR = $(HOME)/distr

# tool
CURL   = curl -L -o
DC     = /usr/bin/dmd
DUB    = /usr/bin/dub
RUN    = $(DUB) run   --compiler=$(DC)
BLD    = $(DUB) build --compiler=$(DC)
DOTNET = /usr/bin/dotnet
PY     = bin/python3
PIP    = bin/pip3

# package
NET_URL = https://packages.microsoft.com/config/debian/$(DEBIAN_VER)
NET_MS  = packages-microsoft-prod.deb
NET_DEB = $(DISTR)/SDK/$(NET_MS)
NET_APT = /etc/apt/sources.list.d/microsoft-prod.list

# src
F += $(wildcard Fsh/*.f*)
D += $(wildcard src/*.d*)
G ?= pcb/1x2in/grb/1x2in.nc

# all

.PHONY: d
d: bin/$(MODULE) $(G)
	$^

.PHONY: all cli
all: $(MODULE).fsproj $(F)
	$(DOTNET) run $< /t:$(MODULE)

FLD = $(addprefix --load:, $(F))
cli: $(DOTNET) $(F)
	$(DOTNET) fsi --consolecolors+ $(FLD)

bin/Debug/net8.0/$(MODULE): $(MODULE).fsproj $(F)
	dotnet build $< /t:$(MODULE)

.PHONY: lab
lab:
	bin/jupyter $@

# format
.PHONY: format
format: tmp/format_py tmp/format_f tmp/format_d
tmp/format_py: $(Y)
tmp/format_f: $(F)
	$(DOTNET) fantomas --force $? && touch $@
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# rule
bin/$(MODULE): $(D) dub.json Makefile
	$(BLD) && touch $@

# doc
.PHONY: doc
doc:

.PHONY: install update gz ref
install: doc gz ref
	$(MAKE) update
	dub build dfmt
# $(DOTNET) new  tool-manifest
# $(DOTNET) tool install fantomas
# dotnet tool install -v d --global Microsoft.dotnet-interactive
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(MAKE) $(PIP)
	$(PIP) install -U -r requirements.txt
gz:  $(NET_APT)  $(DC) $(DUB)
ref:

$(DC) $(DUB): $(HOME)/distr/SDK/dmd_$(D_VER)_amd64.deb
	sudo dpkg -i $< && sudo touch $(DC) $(DUB)
$(HOME)/distr/SDK/dmd_$(D_VER)_amd64.deb:
	$(CURL) $@ https://downloads.dlang.org/releases/2.x/$(D_VER)/dmd_$(D_VER)-0_amd64.deb

$(PY) $(PIP):
	python3 -m venv .

$(NET_APT): $(NET_DEB)
	sudo dpkg -i $< && sudo touch $@
$(NET_DEB):
	$(CURL) $@ $(NET_URL)/$(NET_MS)
