PY  = bin/python3
PIP = bin/pip3

.PHONY: all
all:

.PHONY: lab
lab:
	bin/jupyter $@

.PHONY: format
format: tmp/format_py

.PHONY: install update ref gz
install:
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
	$(MAKE) $(PIP)
	$(PIP) install -U -r requirements.txt
ref:
gz:

$(PY) $(PIP):
	python3 -m venv .
