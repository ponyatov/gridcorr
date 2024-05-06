# var
MODULE  = $(notdir $(CURDIR))

# version
NET_VER    = 8.0.200
DEBIAN_VER = 12

# dir
CWD   = $(CURDIR)
DISTR = $(HOME)/distr

# tool
CURL   = curl -L -o
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
d: $(D) dub.json $(G)
	dub run -- $(G)

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
format: tmp/format_py tmp/format_f
tmp/format_py: $(Y)
tmp/format_f: $(F)
	$(DOTNET) fantomas --force $? && touch $@

.PHONY: install update gz ref
install: gz
	$(MAKE) update
# $(DOTNET) new  tool-manifest
# $(DOTNET) tool install fantomas
# dotnet tool install -v d --global Microsoft.dotnet-interactive
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(MAKE) $(PIP)
	$(PIP) install -U -r requirements.txt
gz:  $(NET_APT)
ref:

$(PY) $(PIP):
	python3 -m venv .

$(NET_APT): $(NET_DEB)
	sudo dpkg -i $< && sudo touch $@
$(NET_DEB):
	$(CURL) $@ $(NET_URL)/$(NET_MS)
